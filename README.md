This project implements a simple APB (Advanced Peripheral Bus) Slave module in SystemVerilog. It supports basic read and write operations to 4 internal registers using the AMBA APB protocol.

## Features

- Fully synchronous APB-compliant slave
- 4 internal 32-bit registers
- Writes occur on `(PSEL && PENABLE && PWRITE)`
- Reads occur on `(PSEL && !PWRITE)`
- Comes with a SystemVerilog testbench
- Generates waveform via VCD (`apb_dump.vcd`)

## Register Map
| Address | Register Index | Notes            |
|---------|----------------|------------------|
| 0x0     | registers[0]   | Writable/Readable |
| 0x4     | registers[1]   | Writable/Readable |
| 0x8     | registers[2]   | Writable/Readable |
| 0xC     | registers[3]   | Writable/Readable |

## Output
RTL Schematic:
Output Waveforms:
