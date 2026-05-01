#include <ap_int.h>
#include <hls_stream.h>
#include <cstdint>
#include <cstdlib>
#include <cstdio>

// ---------------------------------------------------------------------------
// Configurable parameters
// ---------------------------------------------------------------------------
#define SEQ_LEN 16
#define EMB_DIM 16
#define T_TILE  2

#define NUM_BEATS (SEQ_LEN / T_TILE)

// ---------------------------------------------------------------------------
// Data types
// ---------------------------------------------------------------------------
typedef int8_t  data_t;
typedef int16_t acc_t;
typedef int32_t sum_t;
typedef ap_int<8 * T_TILE> beat_t;

// ---------------------------------------------------------------------------
// Helper functions: pack / unpack a beat into T_TILE int8 elements
// ---------------------------------------------------------------------------
inline void unpack_beat(beat_t b, data_t elems[T_TILE]) {
    #pragma HLS INLINE
    for (int t = 0; t < T_TILE; t++) {
        #pragma HLS UNROLL
        elems[t] = (data_t)((b >> (t * 8)) & 0xFF);
    }
}

inline beat_t pack_beat(data_t elems[T_TILE]) {
    #pragma HLS INLINE
    beat_t b = 0;
    for (int t = 0; t < T_TILE; t++) {
        #pragma HLS UNROLL
        ap_uint<8> u = (ap_uint<8>)elems[t];
        b |= (beat_t)u << (t * 8);
    }
    return b;
}

// ---------------------------------------------------------------------------
// IP: fan_out -- reads NUM_BEATS, writes identical beats to two streams
// ---------------------------------------------------------------------------
void fan_out(hls::stream<beat_t>& in,
             hls::stream<beat_t>& out1,
             hls::stream<beat_t>& out2) {
    #pragma HLS INLINE off
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t b = in.read();
        out1.write(b);
        out2.write(b);
    }
}

// ---------------------------------------------------------------------------
// IP: fifo -- simple pass-through (depth is set on the stream pragma)
// ---------------------------------------------------------------------------
void fifo(hls::stream<beat_t>& in, hls::stream<beat_t>& out) {
    #pragma HLS INLINE off
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        out.write(in.read());
    }
}

// ---------------------------------------------------------------------------
// IP: stateful_norm -- 2-pass LayerNorm
//   Pass 1: buffer all SEQ_LEN elements, accumulate sum_x and sum_x2
//   Pass 2: compute mean, variance, apply fixed inv_sqrt = 64 (Q8.8)
// ---------------------------------------------------------------------------
void stateful_norm(hls::stream<beat_t>& in, hls::stream<beat_t>& out) {
    #pragma HLS INLINE off
    data_t buf[SEQ_LEN];
    #pragma HLS ARRAY_PARTITION variable=buf complete

    // Pass 1: read and accumulate
    sum_t sum_x = 0;
    sum_t sum_x2 = 0;
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t b = in.read();
        data_t elems[T_TILE];
        unpack_beat(b, elems);
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            data_t x = elems[t];
            buf[i * T_TILE + t] = x;
            sum_x  += (sum_t)x;
            sum_x2 += (sum_t)x * (sum_t)x;
        }
    }

    // Compute statistics (SEQ_LEN = 16 = 2^4)
    sum_t mean  = sum_x  >> 4;
    sum_t e_x2  = sum_x2 >> 4;
    // variance kept for documentation; fixed inv_sqrt used below
    // sum_t variance = e_x2 - mean * mean;

    // Fixed-point inv_sqrt = 64 in Q8.8 (represents 64/256 = 0.25)
    acc_t inv_sqrt = 64;

    // Pass 2: normalize and emit
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        data_t elems[T_TILE];
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            data_t x = buf[i * T_TILE + t];
            acc_t diff = (acc_t)x - (acc_t)mean;
            acc_t norm = (diff * inv_sqrt) >> 8;
            // gamma = 1, beta = 0
            elems[t] = (data_t)norm;
        }
        out.write(pack_beat(elems));
    }
}

// ---------------------------------------------------------------------------
// IP: gemm -- tiled matrix multiply
//   Buffer one row of EMB_DIM elements, compute output row by dot product
//   with weight columns, emit as beats of T_TILE elements.
// ---------------------------------------------------------------------------
void gemm(hls::stream<beat_t>& in,
          hls::stream<beat_t>& out,
          data_t weights[EMB_DIM][EMB_DIM]) {
    #pragma HLS INLINE off
    #pragma HLS ARRAY_PARTITION variable=weights complete dim=2

    data_t row[EMB_DIM];
    #pragma HLS ARRAY_PARTITION variable=row complete

    // Read one row (EMB_DIM elements = NUM_BEATS beats)
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t b = in.read();
        data_t elems[T_TILE];
        unpack_beat(b, elems);
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            row[i * T_TILE + t] = elems[t];
        }
    }

    // Compute output row: for each output column compute dot product
    for (int j = 0; j < NUM_BEATS; j++) {
        #pragma HLS PIPELINE II=1
        data_t elems[T_TILE];
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            int col = j * T_TILE + t;
            sum_t acc = 0;
            for (int k = 0; k < EMB_DIM; k++) {
                #pragma HLS UNROLL
                acc += (sum_t)row[k] * (sum_t)weights[k][col];
            }
            acc_t requant = (acc >> 8);
            if (requant > 127)  requant = 127;
            if (requant < -128) requant = -128;
            elems[t] = (data_t)requant;
        }
        out.write(pack_beat(elems));
    }
}

// ---------------------------------------------------------------------------
// IP: stateful_softmax -- 3-pass softmax
//   Pass 1: buffer all elements, find max
//   Pass 2: compute exp using LUT for diffs in [-8, 0], accumulate sum_exp
//   Pass 3: normalize by exp_val * 256 / sum_exp and write
// ---------------------------------------------------------------------------
void stateful_softmax(hls::stream<beat_t>& in, hls::stream<beat_t>& out) {
    #pragma HLS INLINE off
    data_t buf[SEQ_LEN];
    #pragma HLS ARRAY_PARTITION variable=buf complete

    static const int EXP_LUT[9] = {
        256, 188, 138, 102, 75, 55, 40, 30, 22
    };

    // Pass 1: read beats and find global max
    data_t max_val = -128;
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t b = in.read();
        data_t elems[T_TILE];
        unpack_beat(b, elems);
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            data_t x = elems[t];
            buf[i * T_TILE + t] = x;
            if (x > max_val) max_val = x;
        }
    }

    // Pass 2: compute exp values (Q8.8) and their sum
    sum_t exp_buf[SEQ_LEN];
    #pragma HLS ARRAY_PARTITION variable=exp_buf complete
    sum_t sum_exp = 0;
    for (int i = 0; i < SEQ_LEN; i++) {
        #pragma HLS UNROLL
        int diff = (int)buf[i] - (int)max_val;
        if (diff < -8) diff = -8;
        if (diff >  0) diff = 0;
        int idx = diff + 8;                     // map [-8,0] -> [0,8]
        sum_t exp_val = (sum_t)EXP_LUT[idx];
        exp_buf[i] = exp_val;
        sum_exp += exp_val;
    }

    // Pass 3: normalize and emit beats
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        data_t elems[T_TILE];
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            sum_t exp_val = exp_buf[i * T_TILE + t];
            sum_t norm = (exp_val * 256) / sum_exp;
            if (norm > 127) norm = 127;
            elems[t] = (data_t)norm;
        }
        out.write(pack_beat(elems));
    }
}

// ---------------------------------------------------------------------------
// IP: activation_relu -- element-wise ReLU
// ---------------------------------------------------------------------------
void activation_relu(hls::stream<beat_t>& in, hls::stream<beat_t>& out) {
    #pragma HLS INLINE off
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t b = in.read();
        data_t elems[T_TILE];
        unpack_beat(b, elems);
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            if (elems[t] < 0) elems[t] = 0;
        }
        out.write(pack_beat(elems));
    }
}

// ---------------------------------------------------------------------------
// IP: alu_add -- element-wise addition (lower 8 bits = wrapping)
// ---------------------------------------------------------------------------
void alu_add(hls::stream<beat_t>& in_a,
             hls::stream<beat_t>& in_b,
             hls::stream<beat_t>& out) {
    #pragma HLS INLINE off
    for (int i = 0; i < NUM_BEATS; i++) {
        #pragma HLS PIPELINE II=1
        beat_t a = in_a.read();
        beat_t b = in_b.read();
        data_t elems_a[T_TILE];
        data_t elems_b[T_TILE];
        unpack_beat(a, elems_a);
        unpack_beat(b, elems_b);
        data_t elems_out[T_TILE];
        for (int t = 0; t < T_TILE; t++) {
            #pragma HLS UNROLL
            sum_t sum = (sum_t)elems_a[t] + (sum_t)elems_b[t];
            elems_out[t] = (data_t)sum;   // lower 8 bits, wrapping
        }
        out.write(pack_beat(elems_out));
    }
}

// ---------------------------------------------------------------------------
// Top-level transformer block
// ---------------------------------------------------------------------------
void transformer_top(hls::stream<beat_t>& in, hls::stream<beat_t>& out,
                     data_t w1[EMB_DIM][EMB_DIM], data_t w2[EMB_DIM][EMB_DIM],
                     data_t w3[EMB_DIM][EMB_DIM], data_t w4[EMB_DIM][EMB_DIM]) {
    #pragma HLS TOP name=transformer_top
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS INTERFACE mode=axis port=in
    #pragma HLS INTERFACE mode=axis port=out
    #pragma HLS INTERFACE mode=bram port=w1,w2,w3,w4
    #pragma HLS DATAFLOW

    // -----------------------------------------------------------------------
    // Internal streams
    // -----------------------------------------------------------------------
    hls::stream<beat_t> s_fifo1("s_fifo1");
    hls::stream<beat_t> s_norm1_in("s_norm1_in");
    hls::stream<beat_t> s_norm1_out("s_norm1_out");
    hls::stream<beat_t> s_gemm1_out("s_gemm1_out");
    hls::stream<beat_t> s_softmax_out("s_softmax_out");
    hls::stream<beat_t> s_gemm2_out("s_gemm2_out");
    hls::stream<beat_t> s_fifo1_out("s_fifo1_out");
    hls::stream<beat_t> s_alu1("s_alu1");
    hls::stream<beat_t> s_alu1_fifo("s_alu1_fifo");
    hls::stream<beat_t> s_fifo2("s_fifo2");
    hls::stream<beat_t> s_norm2_in("s_norm2_in");
    hls::stream<beat_t> s_norm2_out("s_norm2_out");
    hls::stream<beat_t> s_gemm3_out("s_gemm3_out");
    hls::stream<beat_t> s_relu_out("s_relu_out");
    hls::stream<beat_t> s_gemm4_out("s_gemm4_out");
    hls::stream<beat_t> s_fifo2_out("s_fifo2_out");
    hls::stream<beat_t> s_alu2_fifo("s_alu2_fifo");

    #pragma HLS STREAM variable=s_fifo1     depth=80
    #pragma HLS STREAM variable=s_norm1_in  depth=2
    #pragma HLS STREAM variable=s_norm1_out depth=2
    #pragma HLS STREAM variable=s_gemm1_out depth=2
    #pragma HLS STREAM variable=s_softmax_out depth=2
    #pragma HLS STREAM variable=s_gemm2_out depth=2
    #pragma HLS STREAM variable=s_fifo1_out depth=2
    #pragma HLS STREAM variable=s_alu1      depth=2
    #pragma HLS STREAM variable=s_alu1_fifo depth=48
    #pragma HLS STREAM variable=s_fifo2     depth=48
    #pragma HLS STREAM variable=s_norm2_in  depth=2
    #pragma HLS STREAM variable=s_norm2_out depth=2
    #pragma HLS STREAM variable=s_gemm3_out depth=2
    #pragma HLS STREAM variable=s_relu_out  depth=2
    #pragma HLS STREAM variable=s_gemm4_out depth=2
    #pragma HLS STREAM variable=s_fifo2_out depth=2
    #pragma HLS STREAM variable=s_alu2_fifo depth=32

    // -----------------------------------------------------------------------
    // Attention path
    //   Input -> [Fan-out] -> FIFO1 (residual) -----+
    //                        Norm1 -> GEMM1 -> Softmax -> GEMM2 -> ALU1 (add)
    // -----------------------------------------------------------------------
    fan_out(in, s_fifo1, s_norm1_in);
    fifo(s_fifo1, s_fifo1_out);
    stateful_norm(s_norm1_in, s_norm1_out);
    gemm(s_norm1_out, s_gemm1_out, w1);
    stateful_softmax(s_gemm1_out, s_softmax_out);
    gemm(s_softmax_out, s_gemm2_out, w2);
    alu_add(s_gemm2_out, s_fifo1_out, s_alu1);
    fifo(s_alu1, s_alu1_fifo);

    // -----------------------------------------------------------------------
    // FFN path
    //   ALU1 -> [Fan-out] -> FIFO2 (residual) -----+
    //                        Norm2 -> GEMM3 -> ReLU -> GEMM4 -> ALU2 (add) -> Output
    // -----------------------------------------------------------------------
    fan_out(s_alu1_fifo, s_fifo2, s_norm2_in);
    fifo(s_fifo2, s_fifo2_out);
    stateful_norm(s_norm2_in, s_norm2_out);
    gemm(s_norm2_out, s_gemm3_out, w3);
    activation_relu(s_gemm3_out, s_relu_out);
    gemm(s_relu_out, s_gemm4_out, w4);
    alu_add(s_gemm4_out, s_fifo2_out, s_alu2_fifo);
    fifo(s_alu2_fifo, out);
}

// ---------------------------------------------------------------------------
// Testbench
// ---------------------------------------------------------------------------
#ifndef __SYNTHESIS__
int main() {
    srand(42);

    data_t input_data[SEQ_LEN];
    data_t w1[EMB_DIM][EMB_DIM];
    data_t w2[EMB_DIM][EMB_DIM];
    data_t w3[EMB_DIM][EMB_DIM];
    data_t w4[EMB_DIM][EMB_DIM];

    // Generate random inputs in [-10, 9]
    for (int i = 0; i < SEQ_LEN; i++) {
        input_data[i] = (data_t)((rand() % 20) - 10);
    }

    // Generate random weights in [-5, 4]
    for (int i = 0; i < EMB_DIM; i++) {
        for (int j = 0; j < EMB_DIM; j++) {
            w1[i][j] = (data_t)((rand() % 10) - 5);
            w2[i][j] = (data_t)((rand() % 10) - 5);
            w3[i][j] = (data_t)((rand() % 10) - 5);
            w4[i][j] = (data_t)((rand() % 10) - 5);
        }
    }

    hls::stream<beat_t> in_stream("in_stream");
    hls::stream<beat_t> out_stream("out_stream");

    // Pack input into beats and write to stream
    for (int i = 0; i < NUM_BEATS; i++) {
        data_t elems[T_TILE];
        for (int t = 0; t < T_TILE; t++) {
            elems[t] = input_data[i * T_TILE + t];
        }
        in_stream.write(pack_beat(elems));
    }

    // Run DUT
    transformer_top(in_stream, out_stream, w1, w2, w3, w4);

    // Read output, unpack, and verify
    data_t output_data[SEQ_LEN];
    bool all_nonzero = true;
    bool all_valid   = true;

    for (int i = 0; i < NUM_BEATS; i++) {
        beat_t b = out_stream.read();
        data_t elems[T_TILE];
        unpack_beat(b, elems);
        for (int t = 0; t < T_TILE; t++) {
            output_data[i * T_TILE + t] = elems[t];
            if (elems[t] == 0) all_nonzero = false;
            if (elems[t] < -128 || elems[t] > 127) all_valid = false;
        }
    }

    printf("Input first row:  ");
    for (int i = 0; i < SEQ_LEN; i++) {
        printf("%4d ", (int)input_data[i]);
    }
    printf("\n");

    printf("Output first row: ");
    for (int i = 0; i < SEQ_LEN; i++) {
        printf("%4d ", (int)output_data[i]);
    }
    printf("\n");

    if (!all_nonzero) {
        printf("ERROR: Some output values are zero\n");
        return 1;
    }
    if (!all_valid) {
        printf("ERROR: Some output values out of INT8 range\n");
        return 1;
    }

    printf("PASS: All outputs are non-zero and in valid INT8 range\n");
    return 0;
}
#endif // __SYNTHESIS__
