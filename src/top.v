// ============================================================================
// MODULE: top (Top-Level Wrapper)
// ============================================================================
//
// Description:
//   This module is the top-level entity of the CPU8 FPGA project.
//   It instantiates the CPU core and connects it to the physical hardware:
//   - External LEDs
//   - 7-segment display
//   - On-board START and RESET buttons
//   - System clock
//
//   It also implements:
//   - Human-visible execution speed (~1 Hz)
//   - User-controlled execution (START / RESET buttons)
//
// Purpose:
//   - Isolate CPU core from board-specific I/O
//   - Provide a clean synthesis entry point
//   - Keep the CPU fully portable across FPGA boards
//   - Serve as the reference top module for constraints
//
// I/O Summary:
//   Input : clk        -> FPGA system clock (50–125 MHz)
//   Input : btn_start  -> START button (run CPU)
//   Input : btn_reset  -> RESET button (stop + reset CPU)
//   Output: leds       -> 8 external LEDs (binary accumulator display)
//   Output: sevenseg   -> 7-segment display (common cathode)
//
// Execution Behavior:
//   - RESET pressed  -> CPU stopped, PC=0, ACC=0
//   - START pressed  -> CPU starts executing
//   - CPU advances once per second (≈1 Hz)
//
// Board Compatibility:
//   - Xilinx Basys 3
//   - Xilinx Nexys A7
//   - Xilinx Pynq-Z1
//   - Xilinx Cora Z7-07S / Z7-10
//   - Intel DE0-Nano (via Quartus)
//
// Clock Strategy:
//   - Single clock domain
//   - No clock division
//   - Clock enable used for slowing execution (best practice)
//
// Author: Hassan - SinzoTECH Engineering Consultancy
// Date: December 2025
// ============================================================================

module top (
    input  clk,              // System clock
                              // - Provided by FPGA oscillator
                              // - 125 MHz on Cora Z7
                              // - 100 MHz on Basys 3 / Nexys A7
                              
    input  btn_start,         // START button (on-board)
                              // - Active high
                              // - Starts CPU execution
                              
    input  btn_reset,         // RESET button (on-board)
                              // - Active high
                              // - Stops CPU and resets all registers
                              
    output [7:0] leds,        // External LEDs (IO00–IO07)
                              // - Binary display of accumulator
                              
    output [7:0] sevenseg     // 7-segment display (IO26–IO33)
                              // - Common cathode
);

// ============================================================================
// INTERNAL SIGNALS
// ============================================================================

wire [7:0] cpu_leds;         // Accumulator output from CPU core
reg        run;              // CPU execution enable (START/STOP)

// ============================================================================
// CLOCK ENABLE GENERATOR (~1 Hz)
// ============================================================================
//
// Purpose:
//   Slow down CPU execution so changes are visible to the human eye.
//
// Implementation:
//   - Clock runs at full speed (125 MHz)
//   - A counter generates a 1 Hz enable pulse
//   - CPU advances only when enable is asserted
//
// Why NOT divide the clock?
//   - Avoids clock domain issues
//   - Preserves clean synchronous design
//   - Recommended FPGA best practice
//
// ============================================================================

reg [26:0] clk_div;          // Enough bits for 125,000,000 cycles
wire       slow_en;          // 1 Hz enable pulse

always @(posedge clk) begin
    clk_div <= clk_div + 1'b1;
end

assign slow_en = (clk_div == 27'd125_000_000);

// ============================================================================
// START / RESET CONTROL LOGIC
// ============================================================================
//
// Behavior:
//   - RESET button:
//       * Stops CPU
//       * Resets PC and ACC
//
//   - START button:
//       * Enables CPU execution
//       * Ignored if already running
//
// Notes:
//   - Buttons are assumed clean (no debounce for simplicity)
//   - Debounce can be added later if needed
//
// ============================================================================

always @(posedge clk) begin
    if (btn_reset) begin
        run <= 1'b0;         // Stop CPU
    end
    else if (btn_start) begin
        run <= 1'b1;         // Start CPU
    end
end

// ============================================================================
// CPU CORE INSTANTIATION
// ============================================================================
//
// The CPU core is fully generic and portable.
// It advances only when:
//   - run      = 1 (START pressed)
//   - slow_en = 1 (1 Hz tick)
//
// ============================================================================

cpu8 CPU (
    .clk    (clk),           // System clock
    .reset  (btn_reset),     // Synchronous reset
    .enable (run && slow_en),// Execution enable
    .leds   (cpu_leds)       // Accumulator output
);

// ============================================================================
// LED OUTPUT MAPPING
// ============================================================================
//
// Direct binary display of accumulator value.
//
// ============================================================================

assign leds = cpu_leds;

// ============================================================================
// 7-SEGMENT DISPLAY DECODER (COMMON CATHODE)
// ============================================================================
//
// Displays lower 4 bits of accumulator in hexadecimal.
//
// Segment order:
//   sevenseg[0] -> a
//   sevenseg[1] -> b
//   sevenseg[2] -> c
//   sevenseg[3] -> d
//   sevenseg[4] -> e
//   sevenseg[5] -> f
//   sevenseg[6] -> g
//   sevenseg[7] -> decimal point (unused)
//
// ============================================================================

reg [7:0] seg;

always @(*) begin
    case (cpu_leds[3:0])
        4'h0: seg = 8'b00111111;
        4'h1: seg = 8'b00000110;
        4'h2: seg = 8'b01011011;
        4'h3: seg = 8'b01001111;
        4'h4: seg = 8'b01100110;
        4'h5: seg = 8'b01101101;
        4'h6: seg = 8'b01111101;
        4'h7: seg = 8'b00000111;
        4'h8: seg = 8'b01111111;
        4'h9: seg = 8'b01101111;
        4'hA: seg = 8'b01110111;
        4'hB: seg = 8'b01111100;
        4'hC: seg = 8'b00111001;
        4'hD: seg = 8'b01011110;
        4'hE: seg = 8'b01111001;
        4'hF: seg = 8'b01110001;
        default: seg = 8'b00000000;
    endcase
end

assign sevenseg = seg;

// ============================================================================
// END OF MODULE
// ============================================================================

endmodule
