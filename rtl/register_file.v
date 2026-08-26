module register_file (
    input        clk,
    input        reset,

    input        reg_write,
    input  [2:0] read_addr1,
    input  [2:0] read_addr2,
    input  [2:0] write_addr,

    input  [7:0] write_data,

    output [7:0] read_data1,
    output [7:0] read_data2
);

    reg [7:0] registers [0:7];

    integer i;

    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 8'b0;

        end

        else if (reg_write && (write_addr != 3'b000)) begin
            registers[write_addr] <= write_data;
        end

    end

    assign read_data1 = (read_addr1 == 3'b000) ? 8'b0 :
                        registers[read_addr1];

    assign read_data2 = (read_addr2 == 3'b000) ? 8'b0 :
                        registers[read_addr2];

endmodule