`timescale 1ns/1ps

module alu_tb;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [2:0] ALU_SEL;

    wire [7:0] RESULT;
    wire       ZERO;

    alu uut (
        .A(A),
        .B(B),
        .ALU_SEL(ALU_SEL),
        .RESULT(RESULT),
        .ZERO(ZERO)
    );

    task test_operation;
        input [2:0] sel;
        input [7:0] a;
        input [7:0] b;

        begin
            A = a;
            B = b;
            ALU_SEL = sel;

            #10;

            $display(
                "A=%h B=%h SEL=%b RESULT=%h ZERO=%b",
                A, B, ALU_SEL, RESULT, ZERO
            );
        end
    endtask

    initial begin

        $dumpfile("simulation/alu.vcd");
        $dumpvars(0, alu_tb);

        $display("======================================");
        $display("       8-BIT RISC PROCESSOR ALU       ");
        $display("======================================");

        test_operation(3'b000, 8'd10, 8'd5);   // ADD
        test_operation(3'b001, 8'd10, 8'd5);   // SUB
        test_operation(3'b010, 8'hF0, 8'h0F);  // AND
        test_operation(3'b011, 8'hF0, 8'h0F);  // OR
        test_operation(3'b100, 8'hAA, 8'h55);  // XOR
        test_operation(3'b101, 8'h0F, 8'd0);   // NOT
        test_operation(3'b110, 8'd10, 8'd0);   // INCREMENT
        test_operation(3'b111, 8'd10, 8'd0);   // DECREMENT

        $display("======================================");
        $display("             ALU TEST DONE            ");
        $display("======================================");

        #10;
        $finish;

    end

endmodule