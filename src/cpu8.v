// ============================================================================
// MODULE: cpu8
// ============================================================================
//
// Description:
//   Minimal 8-bit accumulator-based CPU designed for FPGA implementation.
//   The CPU executes one instruction per clock cycle (single-cycle design)
//   and is intended for educational, demonstrator, and lightweight control
//   applications.
//
// Architectural Overview:
//   - Architecture type : Accumulator-based
//   - Data width        : 8 bits
//   - Instruction width : 8 bits
//   - Execution model   : Single-cycle (1 instruction / clock)
//   - Control           : Hardwired control (no microcode)
//   - Program storage  : Hardcoded ROM (demo program)
//
// Instruction Format:
//   [7:5] Opcode   (3 bits)
//   [4:0] Immediate / Address (5 bits)
//
// Address Space:
//   - 5-bit address field → 32 instruction addresses
//   - PC stored as 8 bits for simplicity and alignment
//
// Key Features:
//   - Fully synchronous design
//   - Clean reset and enable control
//   - No vendor-specific primitives
//   - Extremely low resource usage
//   - Deterministic and easy-to-debug behavior
//
// Typical Use Case:
//   - CPU core for FPGA teaching labs
//   - Simple state machine replacement
//   - Embedded control logic
//   - HDL interview / portfolio project
//
// Author: Hassan - SinzoTECH Engineering Consultancy
// Date  : December 2025
// ============================================================================

module cpu8 (
    input  clk,         // System clock
                         // - Single global clock
                         // - No clock gating used
                         
    input  reset,       // Synchronous reset (active high)
                         // - Resets PC, ACC and halt flag
                         
    input  enable,      // Execution enable
                         // - When 1: CPU executes instructions
                         // - When 0: CPU is frozen (no PC/ACC update)
                         // - Used for START button and clock enable
                         
    output [7:0] leds   // Output port exposing accumulator value
                         // - Used for LED display and debugging
);

// ============================================================================
// SECTION 1: ARCHITECTURAL REGISTERS
// ============================================================================
//
// The CPU has the minimum possible architectural state:
//   - Program Counter (PC)
//   - Accumulator (ACC)
//   - Halt flag
//
// ============================================================================

reg [7:0] PC;           // Program Counter
                         // - Points to current instruction address
                         // - Only lower 5 bits are used by ROM
                         
reg [7:0] ACC;          // Accumulator
                         // - Primary working register
                         // - All ALU results are written here
                         
reg halt;               // Halt flag
                         // - 0 = CPU running
                         // - 1 = CPU halted (execution stopped)
                         // - Cleared only by reset

// ============================================================================
// SECTION 2: INSTRUCTION FETCH & DECODE
// ============================================================================
//
// Instruction fetch is performed combinationally from ROM.
// Decode splits instruction into opcode and operand.
//
// ============================================================================

wire [7:0] instr;       // Fetched instruction from ROM
                         // Format: [ opcode | immediate ]
                         
wire [2:0] opcode;      // Instruction opcode
wire [4:0] imm;         // Immediate value or jump address

assign opcode = instr[7:5];
assign imm    = instr[4:0];

// ============================================================================
// SECTION 3: PROGRAM ROM
// ============================================================================
//
// Program ROM stores the demo program.
// It is hardcoded for simplicity and portability.
//
// ============================================================================

program_rom ROM (
    .pc    (PC),        // Address input
    .instr(instr)       // Instruction output
);

// ============================================================================
// SECTION 4: ALU (ARITHMETIC LOGIC UNIT)
// ============================================================================
//
// The ALU performs all arithmetic and logical operations.
// It is purely combinational.
//
// Supported operations (example):
//   - LDA  : ACC ← immediate
//   - ADD  : ACC ← ACC + immediate
//   - AND  : ACC ← ACC & immediate
//   - XOR  : ACC ← ACC ^ immediate
//
// ============================================================================

wire [7:0] alu_out;     // Result of ALU operation

alu ALU (
    .acc    (ACC),
    .imm    (imm),
    .opcode (opcode),
    .result (alu_out)
);

// ============================================================================
// SECTION 5: OUTPUT INTERFACE
// ============================================================================
//
// Expose accumulator value directly.
// Used by top-level for LEDs and 7-segment display.
//
// ============================================================================

assign leds = ACC;

// ============================================================================
// SECTION 6: CONTROL UNIT & EXECUTION LOGIC
// ============================================================================
//
// This always block represents the entire control unit of the CPU.
// Because the CPU is single-cycle, all actions occur in one clock edge.
//
// Execution Rules:
//   - If reset = 1  → CPU is initialized
//   - If halt  = 1  → CPU is frozen
//   - If enable = 0 → CPU is frozen
//   - Otherwise     → Execute instruction
//
// ============================================================================

always @(posedge clk) begin

    // ------------------------------------------------------------------------
    // RESET HANDLING
    // ------------------------------------------------------------------------
    // Reset has highest priority and initializes the CPU.
    // ------------------------------------------------------------------------
    if (reset) begin
        PC   <= 8'd0;       // Start execution at address 0
        ACC  <= 8'd0;       // Clear accumulator
        halt <= 1'b0;       // Clear halt flag
    end

    // ------------------------------------------------------------------------
    // EXECUTION STATE
    // ------------------------------------------------------------------------
    // Execute instruction only if:
    //   - CPU is not halted
    //   - Execution is enabled
    // ------------------------------------------------------------------------
    else if (!halt && enable) begin
        case (opcode)

            // ================================================================
            // CONTROL FLOW INSTRUCTIONS
            // ================================================================

            // JMP imm
            // ---------------------------------------------------------------
            // Operation:
            //   PC ← immediate
            // Notes:
            //   - Immediate is 5 bits, zero-extended
            //   - ACC is unchanged
            // ---------------------------------------------------------------
            3'b100: begin
                PC <= {3'b000, imm};
            end

            // HLT
            // ---------------------------------------------------------------
            // Operation:
            //   halt ← 1
            // Notes:
            //   - CPU stops permanently until reset
            // ---------------------------------------------------------------
            3'b111: begin
                halt <= 1'b1;
            end

            // ================================================================
            // DATA PROCESSING INSTRUCTIONS
            // ================================================================
            // Includes:
            //   - LDA
            //   - ADD
            //   - AND
            //   - XOR
            //
            // Common behavior:
            //   ACC ← ALU result
            //   PC  ← PC + 1
            // ================================================================
            default: begin
                ACC <= alu_out;
                PC  <= PC + 8'd1;
            end
        endcase
    end

    // ------------------------------------------------------------------------
    // HALT or DISABLED STATE
    // ------------------------------------------------------------------------
    // If halted or enable=0:
    //   - All registers retain their values
    //   - CPU is effectively paused
    // ------------------------------------------------------------------------
end

// ============================================================================
// END OF MODULE: cpu8
// ============================================================================

endmodule
