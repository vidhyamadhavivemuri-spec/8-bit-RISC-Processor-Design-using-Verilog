module risc_cpu (
    input clk,
    input reset,

    output [7:0] pc,
    output [15:0] instruction,
    output [7:0] alu_result,
    output [7:0] write_back_data
);

    // ==========================================
    // Program Counter
    // ==========================================

    reg [7:0] program_counter;

    assign pc = program_counter;


    // ==========================================
    // Instruction Memory
    // ==========================================

    wire [15:0] current_instruction;

    instruction_memory instruction_mem (
        .address(program_counter),
        .instruction(current_instruction)
    );

    assign instruction = current_instruction;


    // ==========================================
    // Instruction Fields
    // ==========================================

    wire [3:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;

    assign opcode = current_instruction[15:12];
    assign rd     = current_instruction[11:9];
    assign rs1    = current_instruction[8:6];
    assign rs2    = current_instruction[5:3];


    // ==========================================
    // Control Unit
    // ==========================================

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_src;
    wire [2:0] alu_sel;
    wire mem_to_reg;
    wire immediate;

    control_unit control (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .alu_sel(alu_sel),
        .mem_to_reg(mem_to_reg),
        .immediate(immediate)
    );


    // ==========================================
    // Register File
    // ==========================================

    wire [7:0] register_data1;
    wire [7:0] register_data2;

    reg [7:0] register_write_data;

    register_file registers (
        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),

        .read_addr1(rs1),
        .read_addr2(rs2),

        .write_addr(rd),
        .write_data(register_write_data),

        .read_data1(register_data1),
        .read_data2(register_data2)
    );


    // ==========================================
    // ALU Input Selection
    // ==========================================

    reg [7:0] alu_input_b;

    always @(*) begin

        if (immediate)
            alu_input_b = {2'b00, current_instruction[5:0]};
        else
            alu_input_b = register_data2;

    end


    // ==========================================
    // ALU
    // ==========================================

    wire [7:0] alu_output;
    wire zero_flag;

    alu processor_alu (
        .A(register_data1),
        .B(alu_input_b),
        .ALU_SEL(alu_sel),
        .RESULT(alu_output),
        .ZERO(zero_flag)
    );

    assign alu_result = alu_output;


    // ==========================================
    // Data Memory
    // ==========================================

    wire [7:0] memory_read_data;

    data_memory data_mem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(current_instruction[7:0]),
        .write_data(register_data1),

        .read_data(memory_read_data)
    );


    // ==========================================
    // Write Back
    // ==========================================

    always @(*) begin

        if (mem_to_reg)
            register_write_data = memory_read_data;

        else if (opcode == 4'b0101)
            register_write_data = current_instruction[7:0];

        else
            register_write_data = alu_output;

    end

    assign write_back_data = register_write_data;


    // ==========================================
    // Program Counter Update
    // ==========================================

    always @(posedge clk) begin

        if (reset)
            program_counter <= 8'd0;

        else
            program_counter <= program_counter + 8'd1;

    end

endmodule