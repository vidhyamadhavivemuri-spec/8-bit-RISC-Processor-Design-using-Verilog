`timescale 1ns/1ps

module risc_cpu_tb;

    reg clk;
    reg reset;

    wire [7:0] pc;
    wire [15:0] instruction;
    wire [7:0] alu_result;
    wire [7:0] write_back_data;

    // ==========================================
    // CPU
    // ==========================================

    risc_cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .alu_result(alu_result),
        .write_back_data(write_back_data)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;


    // ==========================================
    // Test Program
    // ==========================================

    initial begin

        // MOVI R1, 10
        uut.instruction_mem.memory[0] =
            {4'b0101, 3'b001, 9'b000001010};

        // MOVI R2, 5
        uut.instruction_mem.memory[1] =
            {4'b0101, 3'b010, 9'b000000101};

        // ADD R3, R1, R2
        uut.instruction_mem.memory[2] =
            {4'b0000, 3'b011, 3'b001, 3'b010, 3'b000};

        // SUB R4, R1, R2
        uut.instruction_mem.memory[3] =
            {4'b0001, 3'b100, 3'b001, 3'b010, 3'b000};

        // AND R5, R1, R2
        uut.instruction_mem.memory[4] =
            {4'b0010, 3'b101, 3'b001, 3'b010, 3'b000};

        // OR R6, R1, R2
        uut.instruction_mem.memory[5] =
            {4'b0011, 3'b110, 3'b001, 3'b010, 3'b000};

    end


    // ==========================================
    // Simulation
    // ==========================================

    initial begin

        $dumpfile("simulation/risc_cpu.vcd");
        $dumpvars(0, risc_cpu_tb);

        clk = 0;
        reset = 1;

        #12;

        reset = 0;

        #70;

        $display("");
        $display("======================================");
        $display("        RISC CPU TEST RESULTS         ");
        $display("======================================");

        $display("R1 = %d", uut.registers.registers[1]);
        $display("R2 = %d", uut.registers.registers[2]);
        $display("R3 = %d", uut.registers.registers[3]);
        $display("R4 = %d", uut.registers.registers[4]);
        $display("R5 = %d", uut.registers.registers[5]);
        $display("R6 = %d", uut.registers.registers[6]);

        $display("======================================");

        if (uut.registers.registers[1] == 10 &&
            uut.registers.registers[2] == 5 &&
            uut.registers.registers[3] == 15 &&
            uut.registers.registers[4] == 5 &&
            uut.registers.registers[5] == 0 &&
            uut.registers.registers[6] == 15)

            $display("RISC CPU SUCCESS: All instructions executed correctly!");

        else
            $display("RISC CPU TEST FAILED!");

        $display("======================================");

        $finish;

    end

endmodule