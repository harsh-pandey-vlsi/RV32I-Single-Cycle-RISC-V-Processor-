`timescale 1ns/1ps

module tb_riscv_single_cycle;

    // --------------------------------
    // Clock / Reset
    // --------------------------------
    logic clk;
    logic rst;

    always #5 clk = ~clk;

    // --------------------------------
    // DUT
    // --------------------------------
    riscv_single_cycle dut (
        .clk(clk),
        .rst(rst)
    );

    // --------------------------------
    // Simulation Control
    // --------------------------------
    initial begin
        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        // Run enough cycles
        #300;

        check_results();

        $display("\n===== TEST COMPLETE =====");
        $finish;
    end

    // --------------------------------
    // Debug Monitor
    // --------------------------------
    always @(posedge clk) begin
        $display("Time=%0t | PC=%0d | x5=%0d | x6=%0d | x7=%0d",
            $time,
            dut.pc_inst.pc,
            dut.rf.regs[5],
            dut.rf.regs[6],
            dut.rf.regs[7]
        );
    end

    // --------------------------------
    // Self-Checking Task
    // --------------------------------
    task check_results;
        begin
            $display("\n--- Checking Final State ---");

            // x5 = 10 + 5 = 15
            if (dut.rf.regs[5] !== 32'd15)
                $fatal("FAIL: x5 incorrect. Expected 15");

            // x6 = 5
            if (dut.rf.regs[6] !== 32'd5)
                $fatal("FAIL: x6 incorrect. Expected 5");

            // x7 loaded from memory
            if (dut.rf.regs[7] !== 32'd15)
                $fatal("FAIL: x7 incorrect. Expected 15");

            // Memory[0] should contain 15
            if (dut.dmem.memory[0] !== 32'd15)
                $fatal("FAIL: Memory[0] incorrect");

            // x0 must remain zero
            if (dut.rf.regs[0] !== 32'd0)
                $fatal("FAIL: x0 modified!");

            $display("PASS: All checks successful.");
        end
    endtask

endmodule

