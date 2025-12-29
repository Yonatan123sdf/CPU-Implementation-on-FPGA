// ============================================================================
// MODULE: program_rom (Program Memory / Instruction ROM)
// ============================================================================
// Description:
//   Read-only memory containing the program instructions for the CPU.
//   Implemented as combinational logic using a case statement, which
//   synthesizes to LUTs or small ROM blocks in the FPGA.
//
// Memory Organization:
//   - Address width: 8 bits (though only 5 bits used, addresses 0-31)
//   - Data width: 8 bits (instruction format)
//   - Capacity: 32 instructions (expandable to 256 if needed)
//   - Access time: Combinational (same cycle as address)
//
// Implementation:
//   - Hardcoded program using Verilog case statement
//   - Synthesizes to distributed RAM or LUTs
//   - No clock required (purely combinational)
//   - Default case provides safety for undefined addresses
//
// Demo Program:
//   This ROM contains a simple counting program that demonstrates CPU
//   functionality by incrementing the accumulator continuously.
//
//   Program flow:
//     Address 0: Load value 1 into accumulator
//     Address 1: Add 1 to accumulator (increment)
//     Address 2: Jump back to address 1 (loop)
//     Address 3: Halt (fallback, not normally reached)
//
//   Effect: LEDs display binary counter: 1, 2, 3, 4, ... 255, 0, 1, ...
//
// Design Decisions:
//   - Hardcoded ROM chosen for simplicity and determinism
//   - Case statement preferred over array for clarity
//   - Default case returns HLT to safely handle invalid addresses
//   - Program can be easily modified by changing case statements
//
// To Modify Program:
//   1. Edit the case statements below
//   2. Use ISA encoding: [opcode(3) | immediate(5)]
//   3. Resynthesize the design
//   4. No constraint or pinout changes needed
//
// Resource Usage:
//   - LUTs: ~10-15 (depends on program complexity)
//   - Registers: 0 (purely combinational)
//   - Block RAM: 0 (uses distributed RAM/LUTs)
//
// Author: Hassan - SinzoTECH Engineering Consultancy
// Date: December 2025
// ============================================================================

module program_rom(
    input  [7:0] pc,        // Program counter (address input)
    output reg [7:0] instr  // Instruction output
);

// ============================================================================
// DEMO PROGRAM: Binary Counter
// ============================================================================
// This program creates a continuous counting pattern on the LEDs.
//
// Instruction encoding reference:
//   LDA imm:  000iiiii  (Load immediate into ACC)
//   ADD imm:  001iiiii  (Add immediate to ACC)
//   XOR imm:  010iiiii  (XOR immediate with ACC)
//   AND imm:  011iiiii  (AND immediate with ACC)
//   JMP addr: 100aaaaa  (Jump to address)
//   HLT:      11100000  (Halt execution)
//
// Program listing:
// ============================================================================

always @(*) begin
    case(pc)
        // --------------------------------------------------------------------
        // ADDRESS 0x00: LDA 1
        // --------------------------------------------------------------------
        // Opcode: 000 (LDA)
        // Immediate: 00001 (value = 1)
        // Binary: 00000001
        // Hex: 0x01
        //
        // Operation: ACC ← 1
        // Effect: Initialize accumulator with value 1
        // Next PC: 0x01
        // --------------------------------------------------------------------
        8'h00: instr = 8'b00000001;
        
        // --------------------------------------------------------------------
        // ADDRESS 0x01: ADD 1
        // --------------------------------------------------------------------
        // Opcode: 001 (ADD)
        // Immediate: 00001 (value = 1)
        // Binary: 00100001
        // Hex: 0x21
        //
        // Operation: ACC ← ACC + 1
        // Effect: Increment accumulator by 1
        // Next PC: 0x02
        // --------------------------------------------------------------------
        8'h01: instr = 8'b00100001;
        
        // --------------------------------------------------------------------
        // ADDRESS 0x02: JMP 1
        // --------------------------------------------------------------------
        // Opcode: 100 (JMP)
        // Address: 00001 (jump to address 1)
        // Binary: 10000001
        // Hex: 0x81
        //
        // Operation: PC ← 1
        // Effect: Jump back to ADD instruction, creating an infinite loop
        // Next PC: 0x01 (loop back)
        //
        // Note: This creates the counting pattern:
        //   Cycle 1: ACC=1, PC→1
        //   Cycle 2: ACC=2, PC→2
        //   Cycle 3: ACC=2, PC→1 (JMP doesn't change ACC)
        //   Cycle 4: ACC=3, PC→2
        //   Cycle 5: ACC=3, PC→1 (JMP doesn't change ACC)
        //   ... pattern continues: 1, 2, 3, 4, 5, ... 255, 0, 1, ...
        // --------------------------------------------------------------------
        8'h02: instr = 8'b10000001;
        
        // --------------------------------------------------------------------
        // ADDRESS 0x03: HLT (Fallback)
        // --------------------------------------------------------------------
        // Opcode: 111 (HLT)
        // Binary: 11100000
        // Hex: 0xE0
        //
        // Operation: halt ← 1
        // Effect: Stop CPU execution
        //
        // Note: This instruction is not normally reached because of the
        //       infinite loop at address 0x02. It serves as a safety measure
        //       in case the PC somehow advances past the loop.
        // --------------------------------------------------------------------
        8'h03: instr = 8'b11100000;
        
        // --------------------------------------------------------------------
        // DEFAULT: HLT (Safety for undefined addresses)
        // --------------------------------------------------------------------
        // For any address not explicitly defined (4-255), return HLT instruction.
        // This ensures that if PC goes out of bounds, the CPU safely halts
        // instead of executing garbage instructions.
        // --------------------------------------------------------------------
        default: instr = 8'b11100000;  // HLT for undefined addresses
    endcase
end

endmodule

// ============================================================================
// ALTERNATIVE DEMO PROGRAMS:
// ============================================================================
//
// To change the behavior, replace the case statements above with one of these:
//
// --------------------------------------------------------------------
// Example 1: Count by 2s (0, 2, 4, 6, ...)
// --------------------------------------------------------------------
// 8'h00: instr = 8'b00000000;  // LDA 0
// 8'h01: instr = 8'b00100010;  // ADD 2
// 8'h02: instr = 8'b10000001;  // JMP 1
//
// --------------------------------------------------------------------
// Example 2: Blinking pattern (all LEDs toggle)
// --------------------------------------------------------------------
// 8'h00: instr = 8'b00011111;  // LDA 31 (0x1F = 00011111)
// 8'h01: instr = 8'b01011111;  // XOR 31 (toggles all 5 bits)
// 8'h02: instr = 8'b10000001;  // JMP 1
//
// --------------------------------------------------------------------
// Example 3: Walking bit pattern (one LED at a time)
// --------------------------------------------------------------------
// Requires more complex program with conditional logic (future enhancement)
//
// ============================================================================
