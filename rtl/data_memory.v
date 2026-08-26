module data_memory (
    input        clk,
    input        mem_read,
    input        mem_write,

    input  [7:0] address,
    input  [7:0] write_data,

    output [7:0] read_data
);

    reg [7:0] memory [0:255];

    // Read operation
    assign read_data = mem_read ? memory[address] : 8'b0;

    // Write operation
    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end

endmodule