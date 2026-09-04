import traffic_pkg::*;

module traffic_light_fsm (
  input  logic clk,
  input  logic rst_n,

  input  logic pedestrian_req,
  input  logic emergency,

  output logic [1:0] main_light,
  output logic [1:0] cross_light,
  output logic       walk_signal
);

  state_t     state, next_state;
  logic [5:0] timer;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      state <= S_MAIN_GREEN;
      timer <= T_MAIN_GREEN[5:0];
    end else begin
      if (next_state != state) begin
        state <= next_state;
        case (next_state)
          S_MAIN_GREEN:     timer <= T_MAIN_GREEN[5:0];
          S_MAIN_YELLOW:    timer <= T_MAIN_YELLOW[5:0];
          S_CROSS_RED_WAIT: timer <= T_CROSS_RED_WAIT[5:0];
          S_CROSS_GREEN:    timer <= T_CROSS_GREEN[5:0];
          S_WALK:           timer <= T_WALK[5:0];
          default:          timer <= 6'd0;
        endcase
      end else begin
        if (timer > 0) timer <= timer - 1;
      end
    end
  end

  always_comb begin
    next_state = state;

    if (emergency) begin
      next_state = S_EMERGENCY;
    end else begin
      case (state)
        S_MAIN_GREEN:
          if (timer == 0) next_state = S_MAIN_YELLOW;

        S_MAIN_YELLOW:
          if (timer == 0) next_state = S_CROSS_RED_WAIT;

        S_CROSS_RED_WAIT:
          if (timer == 0)
            next_state = pedestrian_req ? S_WALK : S_CROSS_GREEN;

        S_CROSS_GREEN:
          if (timer == 0) next_state = S_MAIN_GREEN;

        S_WALK:
          if (timer == 0) next_state = S_MAIN_GREEN;

        S_EMERGENCY:
          if (!emergency) next_state = S_MAIN_GREEN;

        default: next_state = S_MAIN_GREEN;
      endcase
    end
  end

  always_comb begin
    main_light  = LIGHT_RED;
    cross_light = LIGHT_RED;
    walk_signal = 1'b0;

    case (state)
      S_MAIN_GREEN:     main_light  = LIGHT_GREEN;
      S_MAIN_YELLOW:    main_light  = LIGHT_YELLOW;
      S_CROSS_RED_WAIT: ;
      S_CROSS_GREEN:    cross_light = LIGHT_GREEN;
      S_WALK:           walk_signal = 1'b1;
      S_EMERGENCY:      ;
      default:          ;
    endcase
  end

endmodule
