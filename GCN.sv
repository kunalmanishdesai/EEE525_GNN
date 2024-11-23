module GCN
  #(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)	
)
(
  input logic clk,	// Clock
  input logic reset,	// Reset 
  input logic start,
  input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1], //FM and WM Data
  input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream

  output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix 
  output logic [ADDRESS_WIDTH-1:0] read_address, // The Address to read the FM and WM Data
  output logic enable_read, // Enabling the Read of the FM and WM Data
  output logic done, // Done signal indicating that all the calculations have been completed
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1] // The answer to the argmax and matrix multiplication 
); 

	logic done_trans;
	logic done_coo;
	logic [15:0] fm_wm_out_TB [0:2];
	logic [2:0] read_row_trans;
	logic [15:0] adj_fm_wm_row [0:2];
	logic [2:0] read_row_coo;


	Transformation_block transformation
	(
  		.clk(clk),
  		.reset(reset),
  		.start(start),
  		.data_in(data_in),
  		.fm_wm_row_out(fm_wm_out_TB),
  		.read_row(read_row_trans),
  		.read_address(read_address),
  		.enable_read(enable_read),
  		.done(done_trans)
	);
	
	COO_BLOCK combination(
		.clk(clk),
		.rst(reset),
		.coo_in(coo_in),
		.done_trans(done_trans),
		.row_data(fm_wm_out_TB),
		.read_row(read_row_coo),
		.coo_add(coo_address),
		.done_comb(done_coo),
		.read_fm_wm_row(read_row_trans),
		.adj_fm_wm_row(adj_fm_wm_row)
	);

	ArgMaxBlock argmax(
		.clk(clk),
		.reset(reset),
		.enable(done_coo),
		.row(adj_fm_wm_row),
		.out(max_addi_answer),
		.read_row(read_row_coo),
		.done(done)
	);
endmodule