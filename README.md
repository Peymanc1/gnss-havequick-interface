# HaveQuick II Interface (GPS ICD-060A Compatible) – FPGA Design

This repository contains an FPGA-based implementation of the **HaveQuick II** timing interface, fully compatible with the **GPS ICD-060A** specification.  
The module was developed as part of a GNSS receiver project and is capable of decoding HQ-II time-of-day information and generating a disciplined **1PPS** output with sub-microsecond accuracy.

---

## ✅ Features

| Feature | Description |
|--------|-------------|
| Protocol compatibility | **HaveQuick II**, **GPS ICD-060A** compliant |
| Input | Time-of-Day serial frame from GNSS receiver |
| Output | 1PPS signal synchronized to GNSS time |
| FPGA implementation | RTL (Verilog/SystemVerilog) |
| Debug support | Integrated timestamp counter & logic analyzer hooks |

---

## 📂 Repository Structure

docs/
  HaveQuick_Report.pdf     <- Full 21-page design report
src/
  rtl/                     <- HDL source files (HaveQuick decoder, PPS generator, state machine)
  sim/                     <- Testbench and simulation scripts
images/
  block_diagram.png        <- High-level architecture (optional)
README.md

## 🗒️ Quick Overview

**HaveQuick II** is a timing protocol used in GNSS systems to distribute precise time-of-day information over serial links.  
This design implements the full HQ-II frame decoding and internal time synchronization logic as defined in **GPS ICD-060A**, including:

- serial frame parsing (BAUD, symbol framing and sync pattern detection)  
- BCD to binary conversion of time fields  
- internal epoch counter  
- 1PPS pulse generation  
- out-of-range and TOD validation checks  

---

## 📄 Full Report

For a detailed description of the design, architecture and test results please refer to:

👉 `docs/HaveQuick_Report.pdf`

---

## 👨‍💻 Author

**Peyman Cibalı**  
Gazi University – Electrical & Electronics Engineering  
