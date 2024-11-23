

module COO_FSM 
(
  input logic clk,
  input logic reset,
  input logic [2:0] counter,
  input logic start,
  input logic [2:0] coo_in [0:1],
  input logic [2:0] read_row,

  output logic enable_write_fm_wm_prod,
  output logic enable_counter,
  output logic [2:0] node1,
  output logic [2:0] node2,
  output logic done
);

  typedef enum logic [2:0] {
	START,
    	ADD1,
	ADD2,
	INCREMENT_COUNTER,
	DONE
  } state_t;

  state_t current_state, next_state;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      current_state <= START;
    else
      current_state <= next_state;

  always_comb begin
    case (current_state)

      START: begin
		enable_write_fm_wm_prod = 1'b0;
		enable_counter = 1'b0;
		node1 = coo_in[0]-1;
		node2 = coo_in[1]-1;
		done = 1'b0;

		if (start) begin
			next_state = ADD1;
		end 
		else begin 
			next_state = START;
		end 
        	
      end

      ADD1: begin
		enable_write_fm_wm_prod = 1'b1;
		enable_counter = 1'b0;
		node1 = coo_in[0]-1;
		node2 = coo_in[1]-1;
		done = 1'b0;

		if (counter == 6) begin
			next_state = DONE;
		end 
		else  begin
			next_state = ADD2;
		end

      end

      ADD2: begin
		enable_write_fm_wm_prod = 1'b1;
		enable_counter = 1'b1;
		done = 1'b0;
		node1 = coo_in[1]-1;
		node2 = coo_in[0]-1;

		next_state = ADD1;
      end

      DONE: begin
		enable_write_fm_wm_prod = 1'b0;
		enable_counter = 1'b0;
		done = 1'b1;
		node1 = read_row;
		node2 = 2'b00;

		next_state = DONE;
      end
    endcase
  end

endmodule