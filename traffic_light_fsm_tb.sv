`timescale 1ns/1ps
import traffic_pkg::*;

module traffic_light_fsm_tb;

  logic clk, rst_n;
  logic pedestrian_req, emergency;
  logic [1:0] main_light, cross_light;
  logic walk_signal;

  traffic_light_fsm dut (.*);

  always #5 clk = ~clk;

  int pass_cnt = 0, fail_cnt = 0;

  task automatic tick (int n = 1);
    repeat (n) @(posedge clk); #1;
  endtask

  task automatic assert_lights (
    logic [1:0] exp_main, exp_cross,
    logic       exp_walk,
    string      label
  );
    if (main_light === exp_main && cross_light === exp_cross && walk_signal === exp_walk) begin

      $display("  PASS  %s", label);
      pass_cnt++;
    end else begin
      $display("  FAIL  %s | main=%b cross=%b walk=%b | exp main=%b cross=%b walk=%b",
               label, main_light, cross_light, walk_signal,
               exp_main, exp_cross, exp_walk);
      fail_cnt++;
    end
  endtask

  initial begin
    clk = 0; rst_n = 0; pedestrian_req = 0; emergency = 0;
    $dumpfile("dump.vcd");
    $dumpvars(0, traffic_light_fsm_tb);

    tick(2); rst_n = 1; tick(1);
    assert_lights(LIGHT_GREEN, LIGHT_RED, 0, "Reset -> MAIN_GREEN");

    tick(T_MAIN_GREEN - 1);
    assert_lights(LIGHT_GREEN,  LIGHT_RED, 0, "Still MAIN_GREEN before timeout");
    tick(1);
    assert_lights(LIGHT_YELLOW, LIGHT_RED, 0, "-> MAIN_YELLOW");

    tick(T_MAIN_YELLOW);
    assert_lights(LIGHT_RED, LIGHT_RED, 0, "-> CROSS_RED_WAIT (all red)");

    tick(T_CROSS_RED_WAIT);
    assert_lights(LIGHT_RED, LIGHT_GREEN, 0, "-> CROSS_GREEN (no ped req)");

    tick(T_CROSS_GREEN);
    assert_lights(LIGHT_GREEN, LIGHT_RED, 0, "-> back to MAIN_GREEN");

    tick(T_MAIN_GREEN + T_MAIN_YELLOW);
    pedestrian_req = 1;
    tick(T_CROSS_RED_WAIT);
    pedestrian_req = 0;
    assert_lights(LIGHT_RED, LIGHT_RED, 1, "-> WALK state (pedestrian)");
    tick(T_WALK);
    assert_lights(LIGHT_GREEN, LIGHT_RED, 0, "-> MAIN_GREEN after walk");

    tick(5);
    emergency = 1; tick(1);
    assert_lights(LIGHT_RED, LIGHT_RED, 0, "-> EMERGENCY (all red)");
    tick(5);
    assert_lights(LIGHT_RED, LIGHT_RED, 0, "Still EMERGENCY while asserted");
    emergency = 0; tick(1);
    assert_lights(LIGHT_GREEN, LIGHT_RED, 0, "-> MAIN_GREEN after emergency");

    $display("\n=== %0d passed, %0d failed ===", pass_cnt, fail_cnt);
    if (fail_cnt == 0) $display("PASS");
    else               $display("FAIL");
    $finish;
  end

endmodule
