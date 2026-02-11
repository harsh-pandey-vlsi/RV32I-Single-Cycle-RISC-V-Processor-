module riscv_single_cycle (
    input clk,
    input rst
);

    wire [31:0] pc, pc_next;
    wire [31:0] instr;

    wire [31:0] rd1, rd2;
    wire [31:0] imm_out;
    wire [31:0] alu_in2;
    wire [31:0] alu_result;
    wire [31:0] mem_data;
    wire [31:0] write_back;

    wire RegWrite, MemRead, MemWrite, MemToReg;
    wire ALUSrc, Branch, Jump;
    wire [1:0] ALUOp;
    wire [2:0] ALUControl;
    wire zero;

    wire [6:0] opcode = instr[6:0];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd  = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    // PC
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Instruction Memory
    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    // Control Unit
    control_unit ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // Register File
    reg_file rf (
        .clk(clk),
        .we(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_back),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Immediate Generator
    imm_gen imm (
        .instr(instr),
        .imm_out(imm_out)
    );

    // ALU Control
    alu_control alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    assign alu_in2 = (ALUSrc) ? imm_out : rd2;

    // ALU
    alu alu_inst (
        .a(rd1),
        .b(alu_in2),
        .alu_ctrl(ALUControl),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    data_mem dmem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(mem_data)
    );

    // Write Back
    assign write_back = (MemToReg) ? mem_data : alu_result;

    // PC Logic
    wire branch_taken = Branch & zero;

    assign pc_next = (Jump) ? alu_result :
                     (branch_taken) ? pc + imm_out :
                     pc + 4;

endmodule

