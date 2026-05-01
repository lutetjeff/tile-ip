#include "hls_signal_handler.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <list>
#include <map>
#include <vector>
#include "ap_fixed.h"
#include "ap_int.h"
#include "hls_directio.h"
#include "hls_stream.h"
using namespace std;

namespace hls::sim
{
  template<size_t n>
  struct Byte {
    unsigned char a[n];

    Byte()
    {
      for (size_t i = 0; i < n; ++i) {
        a[i] = 0;
      }
    }

    template<typename T>
    Byte<n>& operator= (const T &val)
    {
      std::memcpy(a, &val, n);
      return *this;
    }
  };

  struct SimException : public std::exception {
    const std::string msg;
    const size_t line;
    SimException(const std::string &msg, const size_t line)
      : msg(msg), line(line)
    {
    }
  };

  void errExit(const size_t line, const std::string &msg)
  {
    std::string s;
    s += "ERROR";
//  s += '(';
//  s += __FILE__;
//  s += ":";
//  s += std::to_string(line);
//  s += ')';
    s += ": ";
    s += msg;
    s += "\n";
    fputs(s.c_str(), stderr);
    exit(1);
  }
}


namespace hls::sim
{
  struct Buffer {
    char *first;
    Buffer(char *addr) : first(addr)
    {
    }
  };

  struct DBuffer : public Buffer {
    static const size_t total = 1<<10;
    size_t ufree;

    DBuffer(size_t usize) : Buffer(nullptr), ufree(total)
    {
      first = new char[usize*ufree];
    }

    ~DBuffer()
    {
      delete[] first;
    }
  };

  struct CStream {
    char *front;
    char *back;
    size_t num;
    size_t usize;
    std::list<Buffer*> bufs;
    bool dynamic;

    CStream() : front(nullptr), back(nullptr),
                num(0), usize(0), dynamic(true)
    {
    }

    ~CStream()
    {
      for (Buffer *p : bufs) {
        delete p;
      }
    }

    template<typename T>
    T* data()
    {
      return (T*)front;
    }

    template<typename T>
    void transfer(hls::stream<T> *param)
    {
      while (!empty()) {
        param->write(*(T*)nextRead());
      }
    }

    bool empty();
    char* nextRead();
    char* nextWrite();
  };

  bool CStream::empty()
  {
    return num == 0;
  }

  char* CStream::nextRead()
  {
    assert(num > 0);
    char *res = front;
    front += usize;
    if (dynamic) {
      if (++static_cast<DBuffer*>(bufs.front())->ufree == DBuffer::total) {
        if (bufs.size() > 1) {
          bufs.pop_front();
          front = bufs.front()->first;
        } else {
          front = back = bufs.front()->first;
        }
      }
    }
    --num;
    return res;
  }

  char* CStream::nextWrite()
  {
    if (dynamic) {
      if (static_cast<DBuffer*>(bufs.back())->ufree == 0) {
        bufs.push_back(new DBuffer(usize));
        back = bufs.back()->first;
      }
      --static_cast<DBuffer*>(bufs.back())->ufree;
    }
    char *res = back;
    back += usize;
    ++num;
    return res;
  }

  std::list<CStream> streams;
  std::map<char*, CStream*> prebuilt;

  CStream* createStream(size_t usize)
  {
    streams.emplace_front();
    CStream &s = streams.front();
    {
      s.dynamic = true;
      s.bufs.push_back(new DBuffer(usize));
      s.front = s.bufs.back()->first;
      s.back = s.front;
      s.num = 0;
      s.usize = usize;
    }
    return &s;
  }

  template<typename T>
  CStream* createStream(hls::stream<T> *param)
  {
    CStream *s = createStream(sizeof(T));
    {
      s->dynamic = true;
      while (!param->empty()) {
        T data = param->read();
        memcpy(s->nextWrite(), (char*)&data, sizeof(T));
      }
      prebuilt[s->front] = s;
    }
    return s;
  }

  template<typename T>
  CStream* createStream(T *param, size_t usize)
  {
    streams.emplace_front();
    CStream &s = streams.front();
    {
      s.dynamic = false;
      s.bufs.push_back(new Buffer((char*)param));
      s.front = s.back = s.bufs.back()->first;
      s.usize = usize;
      s.num = ~0UL;
    }
    prebuilt[s.front] = &s;
    return &s;
  }

  CStream* findStream(char *buf)
  {
    return prebuilt.at(buf);
  }
}
class AESL_RUNTIME_BC {
  public:
    AESL_RUNTIME_BC(const char* name) {
      file_token.open( name);
      if (!file_token.good()) {
        cout << "Failed to open tv file " << name << endl;
        exit (1);
      }
      file_token >> mName;//[[[runtime]]]
    }
    ~AESL_RUNTIME_BC() {
      file_token.close();
    }
    int read_size () {
      int size = 0;
      file_token >> mName;//[[transaction]]
      file_token >> mName;//transaction number
      file_token >> mName;//pop_size
      size = atoi(mName.c_str());
      file_token >> mName;//[[/transaction]]
      return size;
    }
  public:
    fstream file_token;
    string mName;
};
unsigned int ap_apatb_in_cap_bc;
static AESL_RUNTIME_BC __xlx_in_V_size_Reader("../tv/stream_size/stream_size_in_in.dat");
unsigned int ap_apatb_out_cap_bc;
static AESL_RUNTIME_BC __xlx_out_V_size_Reader("../tv/stream_size/stream_size_out_out.dat");
using hls::sim::Byte;
extern "C" void transformer_top(short*, short*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*, Byte<1>*);
extern "C" void apatb_transformer_top_hw(volatile void * __xlx_apatb_param_in, volatile void * __xlx_apatb_param_out, volatile void * __xlx_apatb_param_w1_0, volatile void * __xlx_apatb_param_w1_1, volatile void * __xlx_apatb_param_w1_2, volatile void * __xlx_apatb_param_w1_3, volatile void * __xlx_apatb_param_w1_4, volatile void * __xlx_apatb_param_w1_5, volatile void * __xlx_apatb_param_w1_6, volatile void * __xlx_apatb_param_w1_7, volatile void * __xlx_apatb_param_w1_8, volatile void * __xlx_apatb_param_w1_9, volatile void * __xlx_apatb_param_w1_10, volatile void * __xlx_apatb_param_w1_11, volatile void * __xlx_apatb_param_w1_12, volatile void * __xlx_apatb_param_w1_13, volatile void * __xlx_apatb_param_w1_14, volatile void * __xlx_apatb_param_w1_15, volatile void * __xlx_apatb_param_w2_0, volatile void * __xlx_apatb_param_w2_1, volatile void * __xlx_apatb_param_w2_2, volatile void * __xlx_apatb_param_w2_3, volatile void * __xlx_apatb_param_w2_4, volatile void * __xlx_apatb_param_w2_5, volatile void * __xlx_apatb_param_w2_6, volatile void * __xlx_apatb_param_w2_7, volatile void * __xlx_apatb_param_w2_8, volatile void * __xlx_apatb_param_w2_9, volatile void * __xlx_apatb_param_w2_10, volatile void * __xlx_apatb_param_w2_11, volatile void * __xlx_apatb_param_w2_12, volatile void * __xlx_apatb_param_w2_13, volatile void * __xlx_apatb_param_w2_14, volatile void * __xlx_apatb_param_w2_15, volatile void * __xlx_apatb_param_w3_0, volatile void * __xlx_apatb_param_w3_1, volatile void * __xlx_apatb_param_w3_2, volatile void * __xlx_apatb_param_w3_3, volatile void * __xlx_apatb_param_w3_4, volatile void * __xlx_apatb_param_w3_5, volatile void * __xlx_apatb_param_w3_6, volatile void * __xlx_apatb_param_w3_7, volatile void * __xlx_apatb_param_w3_8, volatile void * __xlx_apatb_param_w3_9, volatile void * __xlx_apatb_param_w3_10, volatile void * __xlx_apatb_param_w3_11, volatile void * __xlx_apatb_param_w3_12, volatile void * __xlx_apatb_param_w3_13, volatile void * __xlx_apatb_param_w3_14, volatile void * __xlx_apatb_param_w3_15, volatile void * __xlx_apatb_param_w4_0, volatile void * __xlx_apatb_param_w4_1, volatile void * __xlx_apatb_param_w4_2, volatile void * __xlx_apatb_param_w4_3, volatile void * __xlx_apatb_param_w4_4, volatile void * __xlx_apatb_param_w4_5, volatile void * __xlx_apatb_param_w4_6, volatile void * __xlx_apatb_param_w4_7, volatile void * __xlx_apatb_param_w4_8, volatile void * __xlx_apatb_param_w4_9, volatile void * __xlx_apatb_param_w4_10, volatile void * __xlx_apatb_param_w4_11, volatile void * __xlx_apatb_param_w4_12, volatile void * __xlx_apatb_param_w4_13, volatile void * __xlx_apatb_param_w4_14, volatile void * __xlx_apatb_param_w4_15) {
using hls::sim::createStream;
auto* sin = createStream((hls::stream<short>*)__xlx_apatb_param_in);
  //Create input buffer for out
  ap_apatb_out_cap_bc = __xlx_out_V_size_Reader.read_size();
  short* __xlx_out_input_buffer= new short[ap_apatb_out_cap_bc];
auto* sout = createStream((hls::stream<short>*)__xlx_apatb_param_out);
  // Collect __xlx_w1_0__tmp_vec
std::vector<Byte<1>> __xlx_w1_0__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_0__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_0)[i]);
}
  int __xlx_size_param_w1_0 = 16;
  int __xlx_offset_param_w1_0 = 0;
  int __xlx_offset_byte_param_w1_0 = 0*1;
  // Collect __xlx_w1_1__tmp_vec
std::vector<Byte<1>> __xlx_w1_1__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_1__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_1)[i]);
}
  int __xlx_size_param_w1_1 = 16;
  int __xlx_offset_param_w1_1 = 0;
  int __xlx_offset_byte_param_w1_1 = 0*1;
  // Collect __xlx_w1_2__tmp_vec
std::vector<Byte<1>> __xlx_w1_2__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_2__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_2)[i]);
}
  int __xlx_size_param_w1_2 = 16;
  int __xlx_offset_param_w1_2 = 0;
  int __xlx_offset_byte_param_w1_2 = 0*1;
  // Collect __xlx_w1_3__tmp_vec
std::vector<Byte<1>> __xlx_w1_3__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_3__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_3)[i]);
}
  int __xlx_size_param_w1_3 = 16;
  int __xlx_offset_param_w1_3 = 0;
  int __xlx_offset_byte_param_w1_3 = 0*1;
  // Collect __xlx_w1_4__tmp_vec
std::vector<Byte<1>> __xlx_w1_4__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_4__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_4)[i]);
}
  int __xlx_size_param_w1_4 = 16;
  int __xlx_offset_param_w1_4 = 0;
  int __xlx_offset_byte_param_w1_4 = 0*1;
  // Collect __xlx_w1_5__tmp_vec
std::vector<Byte<1>> __xlx_w1_5__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_5__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_5)[i]);
}
  int __xlx_size_param_w1_5 = 16;
  int __xlx_offset_param_w1_5 = 0;
  int __xlx_offset_byte_param_w1_5 = 0*1;
  // Collect __xlx_w1_6__tmp_vec
std::vector<Byte<1>> __xlx_w1_6__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_6__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_6)[i]);
}
  int __xlx_size_param_w1_6 = 16;
  int __xlx_offset_param_w1_6 = 0;
  int __xlx_offset_byte_param_w1_6 = 0*1;
  // Collect __xlx_w1_7__tmp_vec
std::vector<Byte<1>> __xlx_w1_7__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_7__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_7)[i]);
}
  int __xlx_size_param_w1_7 = 16;
  int __xlx_offset_param_w1_7 = 0;
  int __xlx_offset_byte_param_w1_7 = 0*1;
  // Collect __xlx_w1_8__tmp_vec
std::vector<Byte<1>> __xlx_w1_8__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_8__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_8)[i]);
}
  int __xlx_size_param_w1_8 = 16;
  int __xlx_offset_param_w1_8 = 0;
  int __xlx_offset_byte_param_w1_8 = 0*1;
  // Collect __xlx_w1_9__tmp_vec
std::vector<Byte<1>> __xlx_w1_9__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_9__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_9)[i]);
}
  int __xlx_size_param_w1_9 = 16;
  int __xlx_offset_param_w1_9 = 0;
  int __xlx_offset_byte_param_w1_9 = 0*1;
  // Collect __xlx_w1_10__tmp_vec
std::vector<Byte<1>> __xlx_w1_10__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_10__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_10)[i]);
}
  int __xlx_size_param_w1_10 = 16;
  int __xlx_offset_param_w1_10 = 0;
  int __xlx_offset_byte_param_w1_10 = 0*1;
  // Collect __xlx_w1_11__tmp_vec
std::vector<Byte<1>> __xlx_w1_11__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_11__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_11)[i]);
}
  int __xlx_size_param_w1_11 = 16;
  int __xlx_offset_param_w1_11 = 0;
  int __xlx_offset_byte_param_w1_11 = 0*1;
  // Collect __xlx_w1_12__tmp_vec
std::vector<Byte<1>> __xlx_w1_12__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_12__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_12)[i]);
}
  int __xlx_size_param_w1_12 = 16;
  int __xlx_offset_param_w1_12 = 0;
  int __xlx_offset_byte_param_w1_12 = 0*1;
  // Collect __xlx_w1_13__tmp_vec
std::vector<Byte<1>> __xlx_w1_13__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_13__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_13)[i]);
}
  int __xlx_size_param_w1_13 = 16;
  int __xlx_offset_param_w1_13 = 0;
  int __xlx_offset_byte_param_w1_13 = 0*1;
  // Collect __xlx_w1_14__tmp_vec
std::vector<Byte<1>> __xlx_w1_14__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_14__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_14)[i]);
}
  int __xlx_size_param_w1_14 = 16;
  int __xlx_offset_param_w1_14 = 0;
  int __xlx_offset_byte_param_w1_14 = 0*1;
  // Collect __xlx_w1_15__tmp_vec
std::vector<Byte<1>> __xlx_w1_15__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w1_15__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w1_15)[i]);
}
  int __xlx_size_param_w1_15 = 16;
  int __xlx_offset_param_w1_15 = 0;
  int __xlx_offset_byte_param_w1_15 = 0*1;
  // Collect __xlx_w2_0__tmp_vec
std::vector<Byte<1>> __xlx_w2_0__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_0__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_0)[i]);
}
  int __xlx_size_param_w2_0 = 16;
  int __xlx_offset_param_w2_0 = 0;
  int __xlx_offset_byte_param_w2_0 = 0*1;
  // Collect __xlx_w2_1__tmp_vec
std::vector<Byte<1>> __xlx_w2_1__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_1__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_1)[i]);
}
  int __xlx_size_param_w2_1 = 16;
  int __xlx_offset_param_w2_1 = 0;
  int __xlx_offset_byte_param_w2_1 = 0*1;
  // Collect __xlx_w2_2__tmp_vec
std::vector<Byte<1>> __xlx_w2_2__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_2__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_2)[i]);
}
  int __xlx_size_param_w2_2 = 16;
  int __xlx_offset_param_w2_2 = 0;
  int __xlx_offset_byte_param_w2_2 = 0*1;
  // Collect __xlx_w2_3__tmp_vec
std::vector<Byte<1>> __xlx_w2_3__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_3__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_3)[i]);
}
  int __xlx_size_param_w2_3 = 16;
  int __xlx_offset_param_w2_3 = 0;
  int __xlx_offset_byte_param_w2_3 = 0*1;
  // Collect __xlx_w2_4__tmp_vec
std::vector<Byte<1>> __xlx_w2_4__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_4__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_4)[i]);
}
  int __xlx_size_param_w2_4 = 16;
  int __xlx_offset_param_w2_4 = 0;
  int __xlx_offset_byte_param_w2_4 = 0*1;
  // Collect __xlx_w2_5__tmp_vec
std::vector<Byte<1>> __xlx_w2_5__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_5__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_5)[i]);
}
  int __xlx_size_param_w2_5 = 16;
  int __xlx_offset_param_w2_5 = 0;
  int __xlx_offset_byte_param_w2_5 = 0*1;
  // Collect __xlx_w2_6__tmp_vec
std::vector<Byte<1>> __xlx_w2_6__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_6__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_6)[i]);
}
  int __xlx_size_param_w2_6 = 16;
  int __xlx_offset_param_w2_6 = 0;
  int __xlx_offset_byte_param_w2_6 = 0*1;
  // Collect __xlx_w2_7__tmp_vec
std::vector<Byte<1>> __xlx_w2_7__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_7__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_7)[i]);
}
  int __xlx_size_param_w2_7 = 16;
  int __xlx_offset_param_w2_7 = 0;
  int __xlx_offset_byte_param_w2_7 = 0*1;
  // Collect __xlx_w2_8__tmp_vec
std::vector<Byte<1>> __xlx_w2_8__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_8__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_8)[i]);
}
  int __xlx_size_param_w2_8 = 16;
  int __xlx_offset_param_w2_8 = 0;
  int __xlx_offset_byte_param_w2_8 = 0*1;
  // Collect __xlx_w2_9__tmp_vec
std::vector<Byte<1>> __xlx_w2_9__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_9__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_9)[i]);
}
  int __xlx_size_param_w2_9 = 16;
  int __xlx_offset_param_w2_9 = 0;
  int __xlx_offset_byte_param_w2_9 = 0*1;
  // Collect __xlx_w2_10__tmp_vec
std::vector<Byte<1>> __xlx_w2_10__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_10__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_10)[i]);
}
  int __xlx_size_param_w2_10 = 16;
  int __xlx_offset_param_w2_10 = 0;
  int __xlx_offset_byte_param_w2_10 = 0*1;
  // Collect __xlx_w2_11__tmp_vec
std::vector<Byte<1>> __xlx_w2_11__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_11__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_11)[i]);
}
  int __xlx_size_param_w2_11 = 16;
  int __xlx_offset_param_w2_11 = 0;
  int __xlx_offset_byte_param_w2_11 = 0*1;
  // Collect __xlx_w2_12__tmp_vec
std::vector<Byte<1>> __xlx_w2_12__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_12__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_12)[i]);
}
  int __xlx_size_param_w2_12 = 16;
  int __xlx_offset_param_w2_12 = 0;
  int __xlx_offset_byte_param_w2_12 = 0*1;
  // Collect __xlx_w2_13__tmp_vec
std::vector<Byte<1>> __xlx_w2_13__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_13__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_13)[i]);
}
  int __xlx_size_param_w2_13 = 16;
  int __xlx_offset_param_w2_13 = 0;
  int __xlx_offset_byte_param_w2_13 = 0*1;
  // Collect __xlx_w2_14__tmp_vec
std::vector<Byte<1>> __xlx_w2_14__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_14__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_14)[i]);
}
  int __xlx_size_param_w2_14 = 16;
  int __xlx_offset_param_w2_14 = 0;
  int __xlx_offset_byte_param_w2_14 = 0*1;
  // Collect __xlx_w2_15__tmp_vec
std::vector<Byte<1>> __xlx_w2_15__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w2_15__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w2_15)[i]);
}
  int __xlx_size_param_w2_15 = 16;
  int __xlx_offset_param_w2_15 = 0;
  int __xlx_offset_byte_param_w2_15 = 0*1;
  // Collect __xlx_w3_0__tmp_vec
std::vector<Byte<1>> __xlx_w3_0__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_0__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_0)[i]);
}
  int __xlx_size_param_w3_0 = 16;
  int __xlx_offset_param_w3_0 = 0;
  int __xlx_offset_byte_param_w3_0 = 0*1;
  // Collect __xlx_w3_1__tmp_vec
std::vector<Byte<1>> __xlx_w3_1__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_1__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_1)[i]);
}
  int __xlx_size_param_w3_1 = 16;
  int __xlx_offset_param_w3_1 = 0;
  int __xlx_offset_byte_param_w3_1 = 0*1;
  // Collect __xlx_w3_2__tmp_vec
std::vector<Byte<1>> __xlx_w3_2__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_2__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_2)[i]);
}
  int __xlx_size_param_w3_2 = 16;
  int __xlx_offset_param_w3_2 = 0;
  int __xlx_offset_byte_param_w3_2 = 0*1;
  // Collect __xlx_w3_3__tmp_vec
std::vector<Byte<1>> __xlx_w3_3__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_3__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_3)[i]);
}
  int __xlx_size_param_w3_3 = 16;
  int __xlx_offset_param_w3_3 = 0;
  int __xlx_offset_byte_param_w3_3 = 0*1;
  // Collect __xlx_w3_4__tmp_vec
std::vector<Byte<1>> __xlx_w3_4__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_4__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_4)[i]);
}
  int __xlx_size_param_w3_4 = 16;
  int __xlx_offset_param_w3_4 = 0;
  int __xlx_offset_byte_param_w3_4 = 0*1;
  // Collect __xlx_w3_5__tmp_vec
std::vector<Byte<1>> __xlx_w3_5__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_5__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_5)[i]);
}
  int __xlx_size_param_w3_5 = 16;
  int __xlx_offset_param_w3_5 = 0;
  int __xlx_offset_byte_param_w3_5 = 0*1;
  // Collect __xlx_w3_6__tmp_vec
std::vector<Byte<1>> __xlx_w3_6__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_6__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_6)[i]);
}
  int __xlx_size_param_w3_6 = 16;
  int __xlx_offset_param_w3_6 = 0;
  int __xlx_offset_byte_param_w3_6 = 0*1;
  // Collect __xlx_w3_7__tmp_vec
std::vector<Byte<1>> __xlx_w3_7__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_7__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_7)[i]);
}
  int __xlx_size_param_w3_7 = 16;
  int __xlx_offset_param_w3_7 = 0;
  int __xlx_offset_byte_param_w3_7 = 0*1;
  // Collect __xlx_w3_8__tmp_vec
std::vector<Byte<1>> __xlx_w3_8__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_8__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_8)[i]);
}
  int __xlx_size_param_w3_8 = 16;
  int __xlx_offset_param_w3_8 = 0;
  int __xlx_offset_byte_param_w3_8 = 0*1;
  // Collect __xlx_w3_9__tmp_vec
std::vector<Byte<1>> __xlx_w3_9__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_9__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_9)[i]);
}
  int __xlx_size_param_w3_9 = 16;
  int __xlx_offset_param_w3_9 = 0;
  int __xlx_offset_byte_param_w3_9 = 0*1;
  // Collect __xlx_w3_10__tmp_vec
std::vector<Byte<1>> __xlx_w3_10__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_10__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_10)[i]);
}
  int __xlx_size_param_w3_10 = 16;
  int __xlx_offset_param_w3_10 = 0;
  int __xlx_offset_byte_param_w3_10 = 0*1;
  // Collect __xlx_w3_11__tmp_vec
std::vector<Byte<1>> __xlx_w3_11__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_11__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_11)[i]);
}
  int __xlx_size_param_w3_11 = 16;
  int __xlx_offset_param_w3_11 = 0;
  int __xlx_offset_byte_param_w3_11 = 0*1;
  // Collect __xlx_w3_12__tmp_vec
std::vector<Byte<1>> __xlx_w3_12__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_12__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_12)[i]);
}
  int __xlx_size_param_w3_12 = 16;
  int __xlx_offset_param_w3_12 = 0;
  int __xlx_offset_byte_param_w3_12 = 0*1;
  // Collect __xlx_w3_13__tmp_vec
std::vector<Byte<1>> __xlx_w3_13__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_13__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_13)[i]);
}
  int __xlx_size_param_w3_13 = 16;
  int __xlx_offset_param_w3_13 = 0;
  int __xlx_offset_byte_param_w3_13 = 0*1;
  // Collect __xlx_w3_14__tmp_vec
std::vector<Byte<1>> __xlx_w3_14__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_14__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_14)[i]);
}
  int __xlx_size_param_w3_14 = 16;
  int __xlx_offset_param_w3_14 = 0;
  int __xlx_offset_byte_param_w3_14 = 0*1;
  // Collect __xlx_w3_15__tmp_vec
std::vector<Byte<1>> __xlx_w3_15__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w3_15__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w3_15)[i]);
}
  int __xlx_size_param_w3_15 = 16;
  int __xlx_offset_param_w3_15 = 0;
  int __xlx_offset_byte_param_w3_15 = 0*1;
  // Collect __xlx_w4_0__tmp_vec
std::vector<Byte<1>> __xlx_w4_0__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_0__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_0)[i]);
}
  int __xlx_size_param_w4_0 = 16;
  int __xlx_offset_param_w4_0 = 0;
  int __xlx_offset_byte_param_w4_0 = 0*1;
  // Collect __xlx_w4_1__tmp_vec
std::vector<Byte<1>> __xlx_w4_1__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_1__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_1)[i]);
}
  int __xlx_size_param_w4_1 = 16;
  int __xlx_offset_param_w4_1 = 0;
  int __xlx_offset_byte_param_w4_1 = 0*1;
  // Collect __xlx_w4_2__tmp_vec
std::vector<Byte<1>> __xlx_w4_2__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_2__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_2)[i]);
}
  int __xlx_size_param_w4_2 = 16;
  int __xlx_offset_param_w4_2 = 0;
  int __xlx_offset_byte_param_w4_2 = 0*1;
  // Collect __xlx_w4_3__tmp_vec
std::vector<Byte<1>> __xlx_w4_3__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_3__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_3)[i]);
}
  int __xlx_size_param_w4_3 = 16;
  int __xlx_offset_param_w4_3 = 0;
  int __xlx_offset_byte_param_w4_3 = 0*1;
  // Collect __xlx_w4_4__tmp_vec
std::vector<Byte<1>> __xlx_w4_4__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_4__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_4)[i]);
}
  int __xlx_size_param_w4_4 = 16;
  int __xlx_offset_param_w4_4 = 0;
  int __xlx_offset_byte_param_w4_4 = 0*1;
  // Collect __xlx_w4_5__tmp_vec
std::vector<Byte<1>> __xlx_w4_5__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_5__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_5)[i]);
}
  int __xlx_size_param_w4_5 = 16;
  int __xlx_offset_param_w4_5 = 0;
  int __xlx_offset_byte_param_w4_5 = 0*1;
  // Collect __xlx_w4_6__tmp_vec
std::vector<Byte<1>> __xlx_w4_6__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_6__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_6)[i]);
}
  int __xlx_size_param_w4_6 = 16;
  int __xlx_offset_param_w4_6 = 0;
  int __xlx_offset_byte_param_w4_6 = 0*1;
  // Collect __xlx_w4_7__tmp_vec
std::vector<Byte<1>> __xlx_w4_7__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_7__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_7)[i]);
}
  int __xlx_size_param_w4_7 = 16;
  int __xlx_offset_param_w4_7 = 0;
  int __xlx_offset_byte_param_w4_7 = 0*1;
  // Collect __xlx_w4_8__tmp_vec
std::vector<Byte<1>> __xlx_w4_8__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_8__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_8)[i]);
}
  int __xlx_size_param_w4_8 = 16;
  int __xlx_offset_param_w4_8 = 0;
  int __xlx_offset_byte_param_w4_8 = 0*1;
  // Collect __xlx_w4_9__tmp_vec
std::vector<Byte<1>> __xlx_w4_9__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_9__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_9)[i]);
}
  int __xlx_size_param_w4_9 = 16;
  int __xlx_offset_param_w4_9 = 0;
  int __xlx_offset_byte_param_w4_9 = 0*1;
  // Collect __xlx_w4_10__tmp_vec
std::vector<Byte<1>> __xlx_w4_10__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_10__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_10)[i]);
}
  int __xlx_size_param_w4_10 = 16;
  int __xlx_offset_param_w4_10 = 0;
  int __xlx_offset_byte_param_w4_10 = 0*1;
  // Collect __xlx_w4_11__tmp_vec
std::vector<Byte<1>> __xlx_w4_11__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_11__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_11)[i]);
}
  int __xlx_size_param_w4_11 = 16;
  int __xlx_offset_param_w4_11 = 0;
  int __xlx_offset_byte_param_w4_11 = 0*1;
  // Collect __xlx_w4_12__tmp_vec
std::vector<Byte<1>> __xlx_w4_12__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_12__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_12)[i]);
}
  int __xlx_size_param_w4_12 = 16;
  int __xlx_offset_param_w4_12 = 0;
  int __xlx_offset_byte_param_w4_12 = 0*1;
  // Collect __xlx_w4_13__tmp_vec
std::vector<Byte<1>> __xlx_w4_13__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_13__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_13)[i]);
}
  int __xlx_size_param_w4_13 = 16;
  int __xlx_offset_param_w4_13 = 0;
  int __xlx_offset_byte_param_w4_13 = 0*1;
  // Collect __xlx_w4_14__tmp_vec
std::vector<Byte<1>> __xlx_w4_14__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_14__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_14)[i]);
}
  int __xlx_size_param_w4_14 = 16;
  int __xlx_offset_param_w4_14 = 0;
  int __xlx_offset_byte_param_w4_14 = 0*1;
  // Collect __xlx_w4_15__tmp_vec
std::vector<Byte<1>> __xlx_w4_15__tmp_vec;
for (size_t i = 0; i < 16; ++i){
__xlx_w4_15__tmp_vec.push_back(((Byte<1>*)__xlx_apatb_param_w4_15)[i]);
}
  int __xlx_size_param_w4_15 = 16;
  int __xlx_offset_param_w4_15 = 0;
  int __xlx_offset_byte_param_w4_15 = 0*1;
  // DUT call
  transformer_top(sin->data<short>(), sout->data<short>(), __xlx_w1_0__tmp_vec.data(), __xlx_w1_1__tmp_vec.data(), __xlx_w1_2__tmp_vec.data(), __xlx_w1_3__tmp_vec.data(), __xlx_w1_4__tmp_vec.data(), __xlx_w1_5__tmp_vec.data(), __xlx_w1_6__tmp_vec.data(), __xlx_w1_7__tmp_vec.data(), __xlx_w1_8__tmp_vec.data(), __xlx_w1_9__tmp_vec.data(), __xlx_w1_10__tmp_vec.data(), __xlx_w1_11__tmp_vec.data(), __xlx_w1_12__tmp_vec.data(), __xlx_w1_13__tmp_vec.data(), __xlx_w1_14__tmp_vec.data(), __xlx_w1_15__tmp_vec.data(), __xlx_w2_0__tmp_vec.data(), __xlx_w2_1__tmp_vec.data(), __xlx_w2_2__tmp_vec.data(), __xlx_w2_3__tmp_vec.data(), __xlx_w2_4__tmp_vec.data(), __xlx_w2_5__tmp_vec.data(), __xlx_w2_6__tmp_vec.data(), __xlx_w2_7__tmp_vec.data(), __xlx_w2_8__tmp_vec.data(), __xlx_w2_9__tmp_vec.data(), __xlx_w2_10__tmp_vec.data(), __xlx_w2_11__tmp_vec.data(), __xlx_w2_12__tmp_vec.data(), __xlx_w2_13__tmp_vec.data(), __xlx_w2_14__tmp_vec.data(), __xlx_w2_15__tmp_vec.data(), __xlx_w3_0__tmp_vec.data(), __xlx_w3_1__tmp_vec.data(), __xlx_w3_2__tmp_vec.data(), __xlx_w3_3__tmp_vec.data(), __xlx_w3_4__tmp_vec.data(), __xlx_w3_5__tmp_vec.data(), __xlx_w3_6__tmp_vec.data(), __xlx_w3_7__tmp_vec.data(), __xlx_w3_8__tmp_vec.data(), __xlx_w3_9__tmp_vec.data(), __xlx_w3_10__tmp_vec.data(), __xlx_w3_11__tmp_vec.data(), __xlx_w3_12__tmp_vec.data(), __xlx_w3_13__tmp_vec.data(), __xlx_w3_14__tmp_vec.data(), __xlx_w3_15__tmp_vec.data(), __xlx_w4_0__tmp_vec.data(), __xlx_w4_1__tmp_vec.data(), __xlx_w4_2__tmp_vec.data(), __xlx_w4_3__tmp_vec.data(), __xlx_w4_4__tmp_vec.data(), __xlx_w4_5__tmp_vec.data(), __xlx_w4_6__tmp_vec.data(), __xlx_w4_7__tmp_vec.data(), __xlx_w4_8__tmp_vec.data(), __xlx_w4_9__tmp_vec.data(), __xlx_w4_10__tmp_vec.data(), __xlx_w4_11__tmp_vec.data(), __xlx_w4_12__tmp_vec.data(), __xlx_w4_13__tmp_vec.data(), __xlx_w4_14__tmp_vec.data(), __xlx_w4_15__tmp_vec.data());
sin->transfer((hls::stream<short>*)__xlx_apatb_param_in);
sout->transfer((hls::stream<short>*)__xlx_apatb_param_out);
// print __xlx_apatb_param_w1_0
for (size_t i = 0; i < __xlx_size_param_w1_0; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_0)[i] = __xlx_w1_0__tmp_vec[__xlx_offset_param_w1_0+i];
}
// print __xlx_apatb_param_w1_1
for (size_t i = 0; i < __xlx_size_param_w1_1; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_1)[i] = __xlx_w1_1__tmp_vec[__xlx_offset_param_w1_1+i];
}
// print __xlx_apatb_param_w1_2
for (size_t i = 0; i < __xlx_size_param_w1_2; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_2)[i] = __xlx_w1_2__tmp_vec[__xlx_offset_param_w1_2+i];
}
// print __xlx_apatb_param_w1_3
for (size_t i = 0; i < __xlx_size_param_w1_3; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_3)[i] = __xlx_w1_3__tmp_vec[__xlx_offset_param_w1_3+i];
}
// print __xlx_apatb_param_w1_4
for (size_t i = 0; i < __xlx_size_param_w1_4; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_4)[i] = __xlx_w1_4__tmp_vec[__xlx_offset_param_w1_4+i];
}
// print __xlx_apatb_param_w1_5
for (size_t i = 0; i < __xlx_size_param_w1_5; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_5)[i] = __xlx_w1_5__tmp_vec[__xlx_offset_param_w1_5+i];
}
// print __xlx_apatb_param_w1_6
for (size_t i = 0; i < __xlx_size_param_w1_6; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_6)[i] = __xlx_w1_6__tmp_vec[__xlx_offset_param_w1_6+i];
}
// print __xlx_apatb_param_w1_7
for (size_t i = 0; i < __xlx_size_param_w1_7; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_7)[i] = __xlx_w1_7__tmp_vec[__xlx_offset_param_w1_7+i];
}
// print __xlx_apatb_param_w1_8
for (size_t i = 0; i < __xlx_size_param_w1_8; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_8)[i] = __xlx_w1_8__tmp_vec[__xlx_offset_param_w1_8+i];
}
// print __xlx_apatb_param_w1_9
for (size_t i = 0; i < __xlx_size_param_w1_9; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_9)[i] = __xlx_w1_9__tmp_vec[__xlx_offset_param_w1_9+i];
}
// print __xlx_apatb_param_w1_10
for (size_t i = 0; i < __xlx_size_param_w1_10; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_10)[i] = __xlx_w1_10__tmp_vec[__xlx_offset_param_w1_10+i];
}
// print __xlx_apatb_param_w1_11
for (size_t i = 0; i < __xlx_size_param_w1_11; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_11)[i] = __xlx_w1_11__tmp_vec[__xlx_offset_param_w1_11+i];
}
// print __xlx_apatb_param_w1_12
for (size_t i = 0; i < __xlx_size_param_w1_12; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_12)[i] = __xlx_w1_12__tmp_vec[__xlx_offset_param_w1_12+i];
}
// print __xlx_apatb_param_w1_13
for (size_t i = 0; i < __xlx_size_param_w1_13; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_13)[i] = __xlx_w1_13__tmp_vec[__xlx_offset_param_w1_13+i];
}
// print __xlx_apatb_param_w1_14
for (size_t i = 0; i < __xlx_size_param_w1_14; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_14)[i] = __xlx_w1_14__tmp_vec[__xlx_offset_param_w1_14+i];
}
// print __xlx_apatb_param_w1_15
for (size_t i = 0; i < __xlx_size_param_w1_15; ++i) {
((Byte<1>*)__xlx_apatb_param_w1_15)[i] = __xlx_w1_15__tmp_vec[__xlx_offset_param_w1_15+i];
}
// print __xlx_apatb_param_w2_0
for (size_t i = 0; i < __xlx_size_param_w2_0; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_0)[i] = __xlx_w2_0__tmp_vec[__xlx_offset_param_w2_0+i];
}
// print __xlx_apatb_param_w2_1
for (size_t i = 0; i < __xlx_size_param_w2_1; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_1)[i] = __xlx_w2_1__tmp_vec[__xlx_offset_param_w2_1+i];
}
// print __xlx_apatb_param_w2_2
for (size_t i = 0; i < __xlx_size_param_w2_2; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_2)[i] = __xlx_w2_2__tmp_vec[__xlx_offset_param_w2_2+i];
}
// print __xlx_apatb_param_w2_3
for (size_t i = 0; i < __xlx_size_param_w2_3; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_3)[i] = __xlx_w2_3__tmp_vec[__xlx_offset_param_w2_3+i];
}
// print __xlx_apatb_param_w2_4
for (size_t i = 0; i < __xlx_size_param_w2_4; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_4)[i] = __xlx_w2_4__tmp_vec[__xlx_offset_param_w2_4+i];
}
// print __xlx_apatb_param_w2_5
for (size_t i = 0; i < __xlx_size_param_w2_5; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_5)[i] = __xlx_w2_5__tmp_vec[__xlx_offset_param_w2_5+i];
}
// print __xlx_apatb_param_w2_6
for (size_t i = 0; i < __xlx_size_param_w2_6; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_6)[i] = __xlx_w2_6__tmp_vec[__xlx_offset_param_w2_6+i];
}
// print __xlx_apatb_param_w2_7
for (size_t i = 0; i < __xlx_size_param_w2_7; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_7)[i] = __xlx_w2_7__tmp_vec[__xlx_offset_param_w2_7+i];
}
// print __xlx_apatb_param_w2_8
for (size_t i = 0; i < __xlx_size_param_w2_8; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_8)[i] = __xlx_w2_8__tmp_vec[__xlx_offset_param_w2_8+i];
}
// print __xlx_apatb_param_w2_9
for (size_t i = 0; i < __xlx_size_param_w2_9; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_9)[i] = __xlx_w2_9__tmp_vec[__xlx_offset_param_w2_9+i];
}
// print __xlx_apatb_param_w2_10
for (size_t i = 0; i < __xlx_size_param_w2_10; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_10)[i] = __xlx_w2_10__tmp_vec[__xlx_offset_param_w2_10+i];
}
// print __xlx_apatb_param_w2_11
for (size_t i = 0; i < __xlx_size_param_w2_11; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_11)[i] = __xlx_w2_11__tmp_vec[__xlx_offset_param_w2_11+i];
}
// print __xlx_apatb_param_w2_12
for (size_t i = 0; i < __xlx_size_param_w2_12; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_12)[i] = __xlx_w2_12__tmp_vec[__xlx_offset_param_w2_12+i];
}
// print __xlx_apatb_param_w2_13
for (size_t i = 0; i < __xlx_size_param_w2_13; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_13)[i] = __xlx_w2_13__tmp_vec[__xlx_offset_param_w2_13+i];
}
// print __xlx_apatb_param_w2_14
for (size_t i = 0; i < __xlx_size_param_w2_14; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_14)[i] = __xlx_w2_14__tmp_vec[__xlx_offset_param_w2_14+i];
}
// print __xlx_apatb_param_w2_15
for (size_t i = 0; i < __xlx_size_param_w2_15; ++i) {
((Byte<1>*)__xlx_apatb_param_w2_15)[i] = __xlx_w2_15__tmp_vec[__xlx_offset_param_w2_15+i];
}
// print __xlx_apatb_param_w3_0
for (size_t i = 0; i < __xlx_size_param_w3_0; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_0)[i] = __xlx_w3_0__tmp_vec[__xlx_offset_param_w3_0+i];
}
// print __xlx_apatb_param_w3_1
for (size_t i = 0; i < __xlx_size_param_w3_1; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_1)[i] = __xlx_w3_1__tmp_vec[__xlx_offset_param_w3_1+i];
}
// print __xlx_apatb_param_w3_2
for (size_t i = 0; i < __xlx_size_param_w3_2; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_2)[i] = __xlx_w3_2__tmp_vec[__xlx_offset_param_w3_2+i];
}
// print __xlx_apatb_param_w3_3
for (size_t i = 0; i < __xlx_size_param_w3_3; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_3)[i] = __xlx_w3_3__tmp_vec[__xlx_offset_param_w3_3+i];
}
// print __xlx_apatb_param_w3_4
for (size_t i = 0; i < __xlx_size_param_w3_4; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_4)[i] = __xlx_w3_4__tmp_vec[__xlx_offset_param_w3_4+i];
}
// print __xlx_apatb_param_w3_5
for (size_t i = 0; i < __xlx_size_param_w3_5; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_5)[i] = __xlx_w3_5__tmp_vec[__xlx_offset_param_w3_5+i];
}
// print __xlx_apatb_param_w3_6
for (size_t i = 0; i < __xlx_size_param_w3_6; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_6)[i] = __xlx_w3_6__tmp_vec[__xlx_offset_param_w3_6+i];
}
// print __xlx_apatb_param_w3_7
for (size_t i = 0; i < __xlx_size_param_w3_7; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_7)[i] = __xlx_w3_7__tmp_vec[__xlx_offset_param_w3_7+i];
}
// print __xlx_apatb_param_w3_8
for (size_t i = 0; i < __xlx_size_param_w3_8; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_8)[i] = __xlx_w3_8__tmp_vec[__xlx_offset_param_w3_8+i];
}
// print __xlx_apatb_param_w3_9
for (size_t i = 0; i < __xlx_size_param_w3_9; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_9)[i] = __xlx_w3_9__tmp_vec[__xlx_offset_param_w3_9+i];
}
// print __xlx_apatb_param_w3_10
for (size_t i = 0; i < __xlx_size_param_w3_10; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_10)[i] = __xlx_w3_10__tmp_vec[__xlx_offset_param_w3_10+i];
}
// print __xlx_apatb_param_w3_11
for (size_t i = 0; i < __xlx_size_param_w3_11; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_11)[i] = __xlx_w3_11__tmp_vec[__xlx_offset_param_w3_11+i];
}
// print __xlx_apatb_param_w3_12
for (size_t i = 0; i < __xlx_size_param_w3_12; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_12)[i] = __xlx_w3_12__tmp_vec[__xlx_offset_param_w3_12+i];
}
// print __xlx_apatb_param_w3_13
for (size_t i = 0; i < __xlx_size_param_w3_13; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_13)[i] = __xlx_w3_13__tmp_vec[__xlx_offset_param_w3_13+i];
}
// print __xlx_apatb_param_w3_14
for (size_t i = 0; i < __xlx_size_param_w3_14; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_14)[i] = __xlx_w3_14__tmp_vec[__xlx_offset_param_w3_14+i];
}
// print __xlx_apatb_param_w3_15
for (size_t i = 0; i < __xlx_size_param_w3_15; ++i) {
((Byte<1>*)__xlx_apatb_param_w3_15)[i] = __xlx_w3_15__tmp_vec[__xlx_offset_param_w3_15+i];
}
// print __xlx_apatb_param_w4_0
for (size_t i = 0; i < __xlx_size_param_w4_0; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_0)[i] = __xlx_w4_0__tmp_vec[__xlx_offset_param_w4_0+i];
}
// print __xlx_apatb_param_w4_1
for (size_t i = 0; i < __xlx_size_param_w4_1; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_1)[i] = __xlx_w4_1__tmp_vec[__xlx_offset_param_w4_1+i];
}
// print __xlx_apatb_param_w4_2
for (size_t i = 0; i < __xlx_size_param_w4_2; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_2)[i] = __xlx_w4_2__tmp_vec[__xlx_offset_param_w4_2+i];
}
// print __xlx_apatb_param_w4_3
for (size_t i = 0; i < __xlx_size_param_w4_3; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_3)[i] = __xlx_w4_3__tmp_vec[__xlx_offset_param_w4_3+i];
}
// print __xlx_apatb_param_w4_4
for (size_t i = 0; i < __xlx_size_param_w4_4; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_4)[i] = __xlx_w4_4__tmp_vec[__xlx_offset_param_w4_4+i];
}
// print __xlx_apatb_param_w4_5
for (size_t i = 0; i < __xlx_size_param_w4_5; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_5)[i] = __xlx_w4_5__tmp_vec[__xlx_offset_param_w4_5+i];
}
// print __xlx_apatb_param_w4_6
for (size_t i = 0; i < __xlx_size_param_w4_6; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_6)[i] = __xlx_w4_6__tmp_vec[__xlx_offset_param_w4_6+i];
}
// print __xlx_apatb_param_w4_7
for (size_t i = 0; i < __xlx_size_param_w4_7; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_7)[i] = __xlx_w4_7__tmp_vec[__xlx_offset_param_w4_7+i];
}
// print __xlx_apatb_param_w4_8
for (size_t i = 0; i < __xlx_size_param_w4_8; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_8)[i] = __xlx_w4_8__tmp_vec[__xlx_offset_param_w4_8+i];
}
// print __xlx_apatb_param_w4_9
for (size_t i = 0; i < __xlx_size_param_w4_9; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_9)[i] = __xlx_w4_9__tmp_vec[__xlx_offset_param_w4_9+i];
}
// print __xlx_apatb_param_w4_10
for (size_t i = 0; i < __xlx_size_param_w4_10; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_10)[i] = __xlx_w4_10__tmp_vec[__xlx_offset_param_w4_10+i];
}
// print __xlx_apatb_param_w4_11
for (size_t i = 0; i < __xlx_size_param_w4_11; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_11)[i] = __xlx_w4_11__tmp_vec[__xlx_offset_param_w4_11+i];
}
// print __xlx_apatb_param_w4_12
for (size_t i = 0; i < __xlx_size_param_w4_12; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_12)[i] = __xlx_w4_12__tmp_vec[__xlx_offset_param_w4_12+i];
}
// print __xlx_apatb_param_w4_13
for (size_t i = 0; i < __xlx_size_param_w4_13; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_13)[i] = __xlx_w4_13__tmp_vec[__xlx_offset_param_w4_13+i];
}
// print __xlx_apatb_param_w4_14
for (size_t i = 0; i < __xlx_size_param_w4_14; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_14)[i] = __xlx_w4_14__tmp_vec[__xlx_offset_param_w4_14+i];
}
// print __xlx_apatb_param_w4_15
for (size_t i = 0; i < __xlx_size_param_w4_15; ++i) {
((Byte<1>*)__xlx_apatb_param_w4_15)[i] = __xlx_w4_15__tmp_vec[__xlx_offset_param_w4_15+i];
}
}
