#!/bin/bash
# ============================================================================
# Simulation Script (for iverilog or ModelSim)
# ============================================================================

echo "=========================================="
echo "CPU8 Simulation"
echo "=========================================="

# For iverilog (if installed)
if command -v iverilog &> /dev/null; then
    echo "Running with Icarus Verilog..."
    iverilog -o cpu8_sim \
        ../src/cpu8.v \
        ../src/alu.v \
        ../src/program_rom.v \
        tb_cpu.v
    
    vvp cpu8_sim
    
    if [ -f cpu8.vcd ]; then
        echo "Waveform saved: cpu8.vcd"
        echo "View with: gtkwave cpu8.vcd"
    fi
else
    echo "Icarus Verilog not found."
    echo "For ModelSim, use:"
    echo "  vlog ../src/*.v tb_cpu.v"
    echo "  vsim -c tb_cpu -do 'run -all; quit'"
fi

echo "=========================================="
echo "Simulation complete"
echo "=========================================="
