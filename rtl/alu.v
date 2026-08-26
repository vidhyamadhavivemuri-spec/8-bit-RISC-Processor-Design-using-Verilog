module alu (
    input  [7:0] A,
    input  [7:0] B,
    input  [2:0] ALU_SEL,
    output reg [7:0] RESULT,
    output reg       ZERO
);

    always @(*) begin

        case (ALU_SEL)

            3'b000: RESULT = A + B;       // ADD
            3'b001: RESULT = A - B;       // SUB
            3'b010: RESULT = A & B;       // AND
            3'b011: RESULT = A | B;       // OR
            3'b100: RESULT = A ^ B;       // XOR
            3'b101: RESULT = ~A;          // NOT
            3'b110: RESULT = A + 8'd1;    // INCREMENT
            3'b111: RESULT = A - 8'd1;    // DECREMENT

            default: RESULT = 8'b0;

        endcase

        if (RESULT == 8'b0)
            ZERO = 1'b1;
        else
            ZERO = 1'b0;

    end

endmodule