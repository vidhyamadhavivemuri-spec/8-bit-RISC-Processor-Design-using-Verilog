`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg reset;
    reg reg_write;

    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg [2:0] write_addr;

    reg [7:0] write_data;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    register_file uut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("simulation/register_file.vcd");
        $dumpvars(0, register_file_tb);

        clk = 0;
        reset = 1;
        reg_write = 0;

        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;

        #10;

        reset = 0;

        // Write 25 to R1
        reg_write = 1;
        write_addr = 3'b001;
        write_data = 8'd25;

        #10;

        // Write 15 to R2
        write_addr = 3'b010;
        write_data = 8'd15;

        #10;

        // Read R1 and R2
        reg_write = 0;
        read_addr1 = 3'b001;
        read_addr2 = 3'b010;

        #10;

        $display("R1 = %d", read_data1);
        $display("R2 = %d", read_data2);

        // Check R0
        read_addr1 = 3'b000;

        #10;

        $display("R0 = %d", read_data1);

        $display("======================================");
        $display("       REGISTER FILE TEST DONE        ");
        $display("======================================");

        $finish;

    end

endmodule