"""Reference implementation of FIFO for verification."""


def fifo_ref(inputs, ready_pattern, depth):
    """Simulate FIFO behavior cycle by cycle.

    Args:
        inputs (list): List of integer input data values (one per cycle).
        ready_pattern (list): List of ready_in values (0 or 1) per cycle.
        depth (int): FIFO depth.

    Returns:
        list: List of (data_out, valid_out, ready_out) tuples per cycle.
    """
    fifo = []
    trace = []

    for data, ready in zip(inputs, ready_pattern):
        valid_out = 1 if fifo else 0
        ready_out = 1 if len(fifo) < depth else 0

        write_en = 1 and ready_out
        read_en = valid_out and ready

        data_out = fifo[0] if fifo else 0

        trace.append((data_out, valid_out, ready_out))

        if write_en:
            fifo.append(data)
        if read_en:
            fifo.pop(0)

    return trace
