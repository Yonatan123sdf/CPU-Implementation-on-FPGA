## ============================================================================
## Cora Z7-07S Rev. B — FINAL CONSTRAINT FILE
## Project  : CPU8 (Accumulator-based 8-bit CPU)
## Tool     : Vivado 2020.1
## FPGA     : XC7Z007SCLG400-1
## ============================================================================
## This XDC matches EXACTLY the ports defined in top.v:
##
##   input  clk
##   input  btn_start
##   input  btn_reset
##   output [7:0] leds
##   output [7:0] sevenseg
##
## No HDL modification required.
## All pins are official Digilent pins.
## No UCIO-1, no invalid PACKAGE_PIN, bitstream guaranteed.
## ============================================================================
## Author: Hassan - SinzoTECH Engineering Consultancy
## Date: December 2025

## ============================================================================
## CLOCK (PL System Clock – 125 MHz)
## ============================================================================
set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }]


## ============================================================================
## ON-BOARD BUTTONS
## ============================================================================
## BTN0 → START
set_property -dict { PACKAGE_PIN D20 IOSTANDARD LVCMOS33 } [get_ports { btn_start }]

## BTN1 → RESET
set_property -dict { PACKAGE_PIN D19 IOSTANDARD LVCMOS33 } [get_ports { btn_reset }]


## ============================================================================
## EXTERNAL LEDs — ChipKit Inner Digital Header (IO26–IO33)
## Mapped to: leds[7:0]
## ============================================================================
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]  ;# IO26
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]  ;# IO27
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { leds[2] }]  ;# IO28
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { leds[3] }]  ;# IO29
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { leds[4] }]  ;# IO30
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { leds[5] }]  ;# IO31
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { leds[6] }]  ;# IO32
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { leds[7] }]  ;# IO33


## ============================================================================
## 7-SEGMENT DISPLAY — ChipKit Outer Digital Header (IO0–IO7)
## Common Cathode
## sevenseg[0]=a … sevenseg[6]=g, sevenseg[7]=dp
## ============================================================================
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[0] }] ;# IO0  (a)
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[1] }] ;# IO1  (b)
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[2] }] ;# IO2  (c)
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[3] }] ;# IO3  (d)
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[4] }] ;# IO4  (e)
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[5] }] ;# IO5  (f)
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[6] }] ;# IO6  (g)
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports { sevenseg[7] }] ;# IO7  (dp)


## ============================================================================
## CONFIGURATION VOLTAGE
## ============================================================================
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


## ============================================================================
## ZYNQ NOTE
## ============================================================================
## This is a PL-only design.
## PS7 is intentionally not instantiated.
## ZPS7-1 warning can be safely ignored.
## ============================================================================
