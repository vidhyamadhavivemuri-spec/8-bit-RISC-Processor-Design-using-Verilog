module control_unit (
    input  [3:0] opcode,

    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       alu_src,
    output reg [2:0] alu_sel,
    output reg       mem_to_reg,
    output reg       immediate
);

    always @(*) begin

        // Default values
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        alu_src = 1'b0;
        alu_sel = 3'b000;
        mem_to_reg = 1'b0;
        immediate = 1'b0;

        case (opcode)

            // ADD
            4'b0000: begin
                reg_write = 1'b1;
                alu_sel = 3'b000;
            end

            // SUB
            4'b0001: begin
                reg_write = 1'b1;
                alu_sel = 3'b001;
            end

            // AND
            4'b0010: begin
                reg_write = 1'b1;
                alu_sel = 3'b010;
            end

            // OR
            4'b0011: begin
                reg_write = 1'b1;
                alu_sel = 3'b011;
            end

            // XOR
            4'b0100: begin
                reg_write = 1'b1;
                alu_sel = 3'b100;
            end

            // MOVI
            4'b0101: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                immediate = 1'b1;
            end

            // LOAD
            4'b0110: begin
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                alu_src = 1'b1;
                immediate = 1'b1;
            end

            // STORE
            4'b0111: begin
                mem_write = 1'b1;
                alu_src = 1'b1;
                immediate = 1'b1;
            end

            default: begin
                reg_write = 1'b0;
            end

        endcase

    end

endmodule