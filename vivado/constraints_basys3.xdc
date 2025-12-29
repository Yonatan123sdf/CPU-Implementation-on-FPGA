## ============================================================================
## Basys 3 — FINAL CONSTRAINT FILE (FULLY COMMENTED)
## Project  : CPU8 (Accumulator-based 8-bit CPU)
## Tool     : Vivado 2020.1
## FPGA     : Xilinx Artix-7 XC7A35T (CPG236-1)
##
## This XDC matches EXACTLY the ports defined in top.v:
##
##   input  clk
##   input  btn_start
##   input  btn_reset
##   output [7:0] leds
##   output [7:0] sevenseg
##
## Board  : Digilent Basys 3
## Author : Hassan - SinzoTECH Engineering Consultancy
## Date   : December 2025
## ============================================================================


## ============================================================================
## CLOCK INPUT
## ============================================================================
## Board Signal : CLK100MHZ
## Board I/O    : System clock
## FPGA Pin     : W5
## Frequency   : 100 MHz
## ============================================================================
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }]


## ============================================================================
## PUSH BUTTONS (ON-BOARD)
## ============================================================================
## btn_start : CPU START / ENABLE
## btn_reset : CPU RESET
##
## Basys 3 buttons:
##   BTNU = Button Up
##   BTNC = Button Center
## ============================================================================

## btn_start → BTNU (Button Up)
## Board Label : BTNU
## FPGA Pin    : T18
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { btn_start }]

## btn_reset → BTNC (Button Center)
## Board Label : BTNC
## FPGA Pin    : W19
set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports { btn_reset }]


## ============================================================================
## USER LEDs (ON-BOARD)
## ============================================================================
## Basys 3 has 8 discrete LEDs labelled LD0 to LD7.
##
## Mapping convention:
##   leds[0] = ACC bit 0 (LSB) → LD0
##   leds[7] = ACC bit 7 (MSB) → LD7
##
## LEDs are ACTIVE HIGH:
##   Logic '1' → LED ON
##   Logic '0' → LED OFF
## ============================================================================

## leds[0] → LD0
## Board I/O : LD0
## FPGA Pin  : U16
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]

## leds[1] → LD1
## Board I/O : LD1
## FPGA Pin  : E19
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]

## leds[2] → LD2
## Board I/O : LD2
## FPGA Pin  : U19
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { leds[2] }]

## leds[3] → LD3
## Board I/O : LD3
## FPGA Pin  : V19
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports { leds[3] }]

## leds[4] → LD4
## Board I/O : LD4
## FPGA Pin  : W18
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { leds[4] }]

## leds[5] → LD5
## Board I/O : LD5
## FPGA Pin  : U15
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { leds[5] }]

## leds[6] → LD6
## Board I/O : LD6
## FPGA Pin  : U14
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { leds[6] }]

## leds[7] → LD7
## Board I/O : LD7
## FPGA Pin  : V14
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { leds[7] }]


## ============================================================================
## 7-SEGMENT DISPLAY (ON-BOARD)
## ============================================================================
## Basys 3 has a 4-digit 7-segment display.
## This design uses ONE digit (segments + decimal point).
##
## IMPORTANT:
## - Display type : COMMON ANODE
## - Segment is ON when driven LOW ('0')
##
## Segment mapping:
##   sevenseg[0] = Segment A
##   sevenseg[1] = Segment B
##   sevenseg[2] = Segment C
##   sevenseg[3] = Segment D
##   sevenseg[4] = Segment E
##   sevenseg[5] = Segment F
##   sevenseg[6] = Segment G
##   sevenseg[7] = Decimal Point (DP)
## ============================================================================

## sevenseg[0] → Segment A (CA)
## Board I/O : CA
## FPGA Pin  : W7
set_property -dict { PACKAGE_PIN W7 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[0] }]

## sevenseg[1] → Segment B (CB)
## Board I/O : CB
## FPGA Pin  : W6
set_property -dict { PACKAGE_PIN W6 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[1] }]

## sevenseg[2] → Segment C (CC)
## Board I/O : CC
## FPGA Pin  : U8
set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[2] }]

## sevenseg[3] → Segment D (CD)
## Board I/O : CD
## FPGA Pin  : V8
set_property -dict { PACKAGE_PIN V8 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[3] }]

## sevenseg[4] → Segment E (CE)
## Board I/O : CE
## FPGA Pin  : U5
set_property -dict { PACKAGE_PIN U5 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[4] }]

## sevenseg[5] → Segment F (CF)
## Board I/O : CF
## FPGA Pin  : V5
set_property -dict { PACKAGE_PIN V5 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[5] }]

## sevenseg[6] → Segment G (CG)
## Board I/O : CG
## FPGA Pin  : U7
set_property -dict { PACKAGE_PIN U7 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[6] }]

## sevenseg[7] → Decimal Point (DP)
## Board I/O : DP
## FPGA Pin  : V7
set_property -dict { PACKAGE_PIN V7 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[7] }]


## ============================================================================
## CONFIGURATION VOLTAGE
## ============================================================================
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


## ============================================================================
## NOTES FOR REVIEWERS / CLIENT
## ============================================================================
## - This design uses only PL logic (no Zynq PS).
## - LEDs are ACTIVE HIGH.
## - 7-segment display is COMMON ANODE (active LOW).
## - Logic inversion for 7-segment must be handled in HDL if required.
## - No HDL changes are required to retarget the design.
## ============================================================================
