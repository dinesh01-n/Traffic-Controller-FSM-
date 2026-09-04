package traffic_pkg;

  typedef enum logic [2:0] {
    S_MAIN_GREEN     = 3'd0,
    S_MAIN_YELLOW    = 3'd1,
    S_CROSS_RED_WAIT = 3'd2,
    S_CROSS_GREEN    = 3'd3,
    S_WALK           = 3'd4,
    S_EMERGENCY      = 3'd5
  } state_t;

  typedef enum logic [1:0] {
    LIGHT_RED    = 2'b00,
    LIGHT_GREEN  = 2'b01,
    LIGHT_YELLOW = 2'b10
  } light_t;

  localparam int T_MAIN_GREEN     = 30;
  localparam int T_MAIN_YELLOW    = 5;
  localparam int T_CROSS_RED_WAIT = 3;
  localparam int T_CROSS_GREEN    = 20;
  localparam int T_WALK           = 15;

endpackage
