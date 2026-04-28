import pyrtl

# Just checking basic syntax for multi-port / multi-bank mem
mem = pyrtl.MemBlock(bitwidth=8, addrwidth=8, name="mem", asynchronous=False)

# Multi-port writes in PyRTL are done with multiple ports via a specific setup, 
# or by using an array of MemBlocks.
mem_banks = [pyrtl.MemBlock(bitwidth=8, addrwidth=8, name=f"bank_{i}", asynchronous=False) for i in range(4)]

