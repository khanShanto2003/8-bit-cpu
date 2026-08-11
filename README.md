# 8-bit CPU — RTL to GDSII (Open-Source Flow)

An 8-bit, Von Neumann, accumulator-based CPU designed and taken **all the way from Verilog RTL to a fully signed-off GDSII layout**, using a 100% open-source EDA toolchain. Built as a learning-and-portfolio project to understand the complete digital IC design flow end-to-end.

**Final signoff: 0 DRC · 0 LVS · 0 Timing (WNS) violations · 0 Antenna violations**

---

## Overview

The CPU (`top_cpu8`) integrates 6 independently designed, simulated, synthesized, and physically-verified sub-blocks into a single top-level design:

| Block | Description |
|---|---|
| `reg8` | 8-bit register |
| `alu8` | 8-bit ALU — arithmetic and logic operations |
| `pc8` | 8-bit program counter |
| `ir8` | Instruction register |
| `mem8` | 16×8 unified single-port memory (Von Neumann — shared instruction/data) |
| `control_unit` | 2-state FETCH/EXEC finite state machine, instruction decode |

All 6 blocks were individually simulated, synthesized, and run through the full RTL-to-GDS flow before final integration under `top_cpu8`.

## Architecture

- **Style:** Von Neumann, accumulator-based (single accumulator register, no general-purpose register file)
- **Control:** 2-state FSM — `FETCH` → `EXEC` → repeat
- **Instruction format:** 4-bit opcode
- **Memory:** 16×8 unified single-port memory, shared between instructions and data

### Instruction Set (ISA)

| Category | Opcodes |
|---|---|
| ALU class | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR` |
| Control / Memory class | `LOAD`, `STORE`, `JUMP`, `JZ`, `HALT` |

Design note: the 3-bit ALU opcode is wired directly from the instruction bits rather than being re-decoded by the control unit, keeping the control logic simpler.

## Verification

Functional simulation (Icarus Verilog + GTKWave) verified correct execution of a test program:

```
LOAD 10   ; ACC ← 10
ADD 20    ; ACC ← ACC + 20
STORE     ; mem[7] ← ACC
HALT
```

Result: `ACC = 30`, `mem[7] = 30` — matches expected behavior.

A notable bug caught and fixed during verification: the accumulator was unconditionally receiving `alu_result`, even on a `LOAD` instruction. Fixed with an explicit mux:
```verilog
acc_d = is_load ? mem_data_out : alu_result;
```

## Physical Design Flow

Full RTL-to-GDSII implementation via [OpenLane 2](https://github.com/The-OpenROAD-Project/OpenLane), synthesized with Yosys, with DRC/LVS/antenna signoff in Magic and KLayout.

**Flow used for every block:**
```
mkdir designs/<design>/src
cp <verified RTL> designs/<design>/src/
# configure designs/<design>/config.json
nix-shell flow.tcl
# → signed-off GDS in designs/<design>/runs/<run>/final/
```

## Final Signoff Metrics (`top_cpu8`)

| Metric | Value |
|---|---|
| Core area | 613,701 µm² |
| Die area | 640,000 µm² |
| Standard cell instances | 9,611 |
| Total power | ~1.03 mW |
| Setup WNS (all PVT corners) | 0.0 ns |
| Setup TNS (all PVT corners) | 0.0 ns |
| Hold violations | 0 |
| DRC errors (Magic) | 0 |
| DRC errors (KLayout) | 0 |
| LVS errors | 0 |
| LVS unmatched devices / nets / pins | 0 / 0 / 0 |
| Antenna violations | 0 |
| Routing DRC errors | 0 |
| XOR (GDS vs. layout) difference | 0 |
| Worst IR drop | 0.29 mV |

PVT corners verified: `nom/min/max` × `tt_025C_1v80`, `ss_100C_1v60`, `ff_n40C_1v95` — all clean.

Full metrics: [`top_cpu8/Final GDS Output/metrics.csv`](./top_cpu8/Final%20GDS%20Output/metrics.csv)

## Toolchain

| Tool | Purpose |
|---|---|
| Icarus Verilog + GTKWave | RTL simulation & waveform debug |
| Yosys | Logic synthesis |
| OpenLane 2 | RTL-to-GDSII flow orchestration |
| OpenROAD | Place & route |
| Magic | DRC / LVS / layout signoff |
| KLayout | GDS inspection, DRC cross-check |
| Nix (WSL2/Ubuntu) | Reproducible OpenLane environment |

## Repository Structure

Each sub-block follows the same layout — RTL through final signed-off GDS:

```
8-bit-cpu/
├── README.md
│
├── alu8/
│   ├── RTL/
│   ├── Simulation/
│   ├── Synthesis/
│   ├── Testbench/
│   └── Final GDS Output/
│       ├── DEF
│       ├── GDS
│       ├── config.json
│       ├── metrics.csv
│       ├── final-gds-layout.jpg
│       └── metrics-csv.jpg
│
├── control_unit/     (same layout as alu8)
├── ir8/               (same layout as alu8)
├── mem8/               (same layout as alu8)
├── pc8/                 (same layout as alu8)
├── reg8/                 (same layout as alu8)
│
└── top_cpu8/
    ├── RTL/
    ├── Simulation/
    ├── Synthesis/
    ├── Testbench/
    └── Final GDS Output/
        ├── DEF
        ├── GDS
        ├── config.json
        ├── metrics.csv
        └── Output Figure/
            ├── Floorplan
            ├── Placement
            ├── Power Distribution Network (PDN)
            ├── Routing
            └── Routing Vias
```

## Extensions

- A **4:1 MUX** was implemented as an additional standalone RTL-to-GDS exercise, applying the same verified flow.

## Author

Shanto — Final-year B.Sc. EEE student, Bangladesh University of Business and Technology (BUBT).
Email: khanshanto2002@gmail.com
