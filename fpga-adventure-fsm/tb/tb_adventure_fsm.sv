`timescale 1ns/1ps
module tb_adventure_fsm;
    logic clk = 0;
    always #5 clk = ~clk;
    logic reset_n = 0;
    logic north = 0, east = 0, south = 0, west = 0, sword = 0;
    logic [2:0] room, state_debug;
    logic win, lose;
    integer checks = 0;

    adventure_fsm dut(.*);

    task automatic check(input logic [2:0] expected, input logic exp_win, input logic exp_lose);
        #1;
        if (state_debug !== expected || room !== expected || win !== exp_win || lose !== exp_lose) begin
            $display("FAIL state=%0d room=%0d win=%0b lose=%0b expected=%0d/%0b/%0b", state_debug, room, win, lose, expected, exp_win, exp_lose);
            $fatal(1, "FSM mismatch");
        end
        checks = checks + 1;
    endtask

    task automatic step(input logic n, input logic e, input logic s, input logic w, input logic sw);
        @(negedge clk);
        north=n; east=e; south=s; west=w; sword=sw;
        @(posedge clk);
        #1;
        north=0; east=0; south=0; west=0;
    endtask

    task automatic restart;
        @(negedge clk); reset_n=0;
        #1; check(0, 0, 0);
        @(negedge clk); reset_n=1;
    endtask

    initial begin
        $dumpfile("build/adventure_fsm.vcd");
        $dumpvars(0, tb_adventure_fsm);
        #2; check(0,0,0);
        @(negedge clk); reset_n=1;
        // Winning run START -> HALL -> DRAGON -> WIN with sword.
        step(1,0,0,0,0); check(1,0,0);
        step(1,0,0,0,0); check(3,0,0);
        step(0,1,0,0,1); check(4,1,0);
        step(0,0,1,0,0); check(4,1,0); // Terminal is sticky.
        restart();
        // Losing run without sword.
        step(1,0,0,0,0); check(1,0,0);
        step(1,0,0,0,0); check(3,0,0);
        step(0,1,0,0,0); check(5,0,1);
        restart();
        // ARMORY and return.
        step(1,0,0,0,0); check(1,0,0);
        step(0,1,0,0,0); check(2,0,0);
        step(0,0,0,1,0); check(1,0,0);
        step(0,0,1,0,0); check(0,0,0);
        // No move on simultaneous inputs.
        step(1,1,0,0,0); check(0,0,0);
        $display("PASS: %0d FSM checks", checks);
        $finish;
    end
endmodule
