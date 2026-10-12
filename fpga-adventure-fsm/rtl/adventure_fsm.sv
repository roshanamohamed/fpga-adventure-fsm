// Educational, synthesizable Moore FSM for a direction-controlled adventure game.
// This is a new portfolio implementation, not an export of an earlier class lab.
module adventure_fsm (
    input  logic clk,
    input  logic reset_n,
    input  logic north,
    input  logic east,
    input  logic south,
    input  logic west,
    input  logic sword,
    output logic [2:0] room,
    output logic win,
    output logic lose,
    output logic [2:0] state_debug
);
    typedef enum logic [2:0] {
        START    = 3'd0,
        HALL     = 3'd1,
        ARMORY   = 3'd2,
        DRAGON   = 3'd3,
        WIN_ROOM = 3'd4,
        LOSE_ROOM= 3'd5
    } state_t;

    state_t state, next_state;
    logic move_valid;
    // Exactly one direction pressed; simultaneous directions are ignored.
    assign move_valid = (north + east + south + west) == 1;

    always_comb begin
        next_state = state;
        if (move_valid) begin
            case (state)
                START:  if (north) next_state = HALL;
                HALL: begin
                    if (east)      next_state = ARMORY;
                    else if (north) next_state = DRAGON;
                    else if (south) next_state = START;
                end
                ARMORY: if (west) next_state = HALL;
                DRAGON: begin
                    if (east) next_state = sword ? WIN_ROOM : LOSE_ROOM;
                    else if (south) next_state = HALL;
                end
                default: next_state = state; // Win and lose are sticky until reset.
            endcase
        end
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) state <= START;
        else          state <= next_state;
    end

    always_comb begin
        room = 3'd0;
        win = 1'b0;
        lose = 1'b0;
        state_debug = state;
        case (state)
            START:     room = 3'd0;
            HALL:      room = 3'd1;
            ARMORY:    room = 3'd2;
            DRAGON:    room = 3'd3;
            WIN_ROOM:  begin room = 3'd4; win = 1'b1; end
            LOSE_ROOM: begin room = 3'd5; lose = 1'b1; end
            default:   begin room = 3'd0; win = 1'b0; lose = 1'b0; end
        endcase
    end
endmodule
