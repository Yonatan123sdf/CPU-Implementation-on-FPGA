// ============================================================================
// MODULE: alu (Arithmetic Logic Unit)
// ============================================================================
// Description:
//   Combinational logic unit that performs all arithmetic and logic operations
//   for the CPU8 processor. Operates on the accumulator and immediate operand.
//
// Operation:
//   - Purely combinational (no registers, no clock)
//   - Result available within same clock cycle
//   - Supports 4 data processing operations
//
// Instruction Set Support:
//   Opcode 000 (LDA): Load immediate into accumulator
//   Opcode 001 (ADD): Add immediate to accumulator
//   Opcode 010 (XOR): Exclusive-OR immediate with accumulator
//   Opcode 011 (AND): Bitwise AND immediate with accumulator
//   Opcode 100 (JMP): Handled by control unit, not ALU
//   Opcode 111 (HLT): Handled by control unit, not ALU
//
// Data Path:
//   Input:  ACC (8-bit) + IMM (5-bit) + OPCODE (3-bit)
//   Output: RESULT (8-bit)
//
// Design Decisions:
//   - Combinational design ensures single-cycle execution
//   - 5-bit immediate provides range 0-31 (sufficient for demo programs)
//   - Zero-extension used for immediate values (not sign-extension)
//   - Pass-through mode for unsupported opcodes (safety feature)
//
// Timing:
//   - Propagation delay: ~2-3 LUT delays
//   - Critical path: typically not the bottleneck in CPU
//
// Resource Usage:
//   - LUTs: ~15-20 (mostly for the adder in ADD operation)
//   - Registers: 0 (purely combinational)
//
// Author: Hassan - SinzoTECH Engineering Consultancy
// Date: December 2025
// ============================================================================

module alu(
    input  [7:0] acc,       // Accumulator input (current value)
    input  [4:0] imm,       // Immediate operand (values 0-31)
    input  [2:0] opcode,    // Operation selector
    output reg [7:0] result // Computed result
);

// ============================================================================
// COMBINATIONAL LOGIC: Operation Decoder and Execution
// ============================================================================
// Decodes the opcode and performs the corresponding operation.
// All operations complete combinationally (no clock required).
//
// Note: The 5-bit immediate is zero-extended to 8 bits for operations.
//       Zero-extension: {000, imm[4:0]} creates values 0x00 to 0x1F
// ============================================================================

always @(*) begin
    case(opcode)
        // --------------------------------------------------------------------
        // LDA imm - Load Immediate
        // --------------------------------------------------------------------
        // Operation: ACC ← immediate
        // Function: Loads a constant value into the accumulator
        // Example: LDA 5 sets ACC = 0x05
        // Use case: Initialize accumulator with a starting value
        // --------------------------------------------------------------------
        3'b000: result = {3'b000, imm};  // Zero-extend 5-bit immediate to 8 bits
        
        // --------------------------------------------------------------------
        // ADD imm - Add Immediate
        // --------------------------------------------------------------------
        // Operation: ACC ← ACC + immediate
        // Function: Adds a constant to the accumulator
        // Example: If ACC=3, ADD 2 sets ACC = 5
        // Use case: Increment counters, compute sums
        // Overflow: Wraps around (0xFF + 0x01 = 0x00)
        // --------------------------------------------------------------------
        3'b001: result = acc + {3'b000, imm};  // 8-bit addition with zero-extended immediate
        
        // --------------------------------------------------------------------
        // XOR imm - Exclusive-OR Immediate
        // --------------------------------------------------------------------
        // Operation: ACC ← ACC ^ immediate
        // Function: Performs bitwise XOR with a constant
        // Example: If ACC=0xFF, XOR 0xFF sets ACC = 0x00
        // Use case: Toggle bits, create alternating patterns
        // Property: XOR with same value twice returns original (A^B^B = A)
        // --------------------------------------------------------------------
        3'b010: result = acc ^ {3'b000, imm};  // Bitwise XOR
        
        // --------------------------------------------------------------------
        // AND imm - Bitwise AND Immediate
        // --------------------------------------------------------------------
        // Operation: ACC ← ACC & immediate
        // Function: Performs bitwise AND with a constant
        // Example: If ACC=0xFF, AND 0x0F sets ACC = 0x0F
        // Use case: Mask/clear specific bits, range limiting
        // Property: AND with 0 clears bits, AND with 1 preserves bits
        // --------------------------------------------------------------------
        3'b011: result = acc & {3'b000, imm};  // Bitwise AND (masking operation)
        
        // --------------------------------------------------------------------
        // DEFAULT - Pass-through
        // --------------------------------------------------------------------
        // For undefined or control-flow opcodes (JMP, HLT), pass ACC unchanged.
        // This ensures the ALU output is stable even when not actively used.
        // The control unit ignores this output for JMP and HLT instructions.
        // --------------------------------------------------------------------
        default: result = acc;  // Preserve accumulator value
    endcase
end

endmodule

// ============================================================================
// IMPLEMENTATION NOTES:
// ============================================================================
// 1. Zero-Extension Rationale:
//    - 5-bit immediate provides range 0-31, adequate for small programs
//    - Zero-extension chosen over sign-extension for simplicity
//    - Negative numbers can be represented using two's complement at 
//      software level if needed
//
// 2. Overflow Handling:
//    - ADD operation allows silent overflow (wraps around)
//    - No carry/overflow flag implemented (minimalist design)
//    - Software must account for wraparound if needed
//
// 3. Future Extensions:
//    - Could add SUB (subtract), OR (bitwise or), NOT (complement)
//    - Could add shift operations (SHL, SHR)
//    - Could add comparison operations (CMP with flag output)
//    - Could add status flags (Zero, Carry, Negative, Overflow)
//
// 4. Verification:
//    - All operations tested in simulation
//    - Adder verified for corner cases (0+0, 255+1)
//    - Bitwise operations verified with truth tables
// ============================================================================
