# T0 Core Implementation
This is an RTL implementation of the [T0 ISA](https://docs.thetamachines.com/architecture/rtmc/motion-controller/t0-isa). It is independent of any target device, meaning it can be ported to any platform as long as a compatible memory controller is written.

The T0 ISA is for research and development and is not intended to be a fully functional motion controller. As such, this core is not meant for production use. 

## Documentation
This core's documentation is available at <https://docs.thetamachines.com/firmware/rtmc-cores/t0-core>


## Status
This project is in the verification phase. As the core goes through verification, patches and breaking changes will occur. 



## Simulating Models
Test benches are located in the `src/` directory. The test benches are written in SystemVerilog along with a `.do` file that tells ModelSim how to compile and run the source files. A test bench can be run within ModelSim using the `do <filename>` command. 

Each test bench also has a `wave.do` file that tells ModelSim which signals to display in the wave window. 



## Assembler (`assembler.py`)
To quickly assemble binary files from T0 assembly files, use the quick-and-dirty `assembler.py` script using the following command:

`python assembler.py <input_file> [-o <output_file>]`



## Design Hierarchy
```
t0_core
├── control_unit
│   ├── fetch_unit
│   ├── decoder
│   ├── gp_table
│   └── update_generator
│
└── datapath
    ├── axis_counter
    ├── cl_table
    ├── esu
    │   └── divider
    ├── solution_table
    └── pgu[0:2]
```
