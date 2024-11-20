// Code your testbench here
// or browse Examples
`timescale 1ps/100fs
module GCN_TB
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
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter HALF_CLOCK_CYCLE = 5
)
();



  string feature_filename = "./data/feature_data.txt"; // modify the path to the files to match your case
  string weight_filename = "./data/weight_data.txt";
  string coo_filename = "./data/coo_data.txt";
  string gold_address_filename = "./data/gold_address.txt";

  logic read_enable;
  logic write_enable;
  logic [DOT_PROD_WIDTH-1:0] wm_fm_dot_product;
  logic [WEIGHT_WIDTH-1:0] input_data [0:WEIGHT_ROWS-1];

  logic [ADDRESS_WIDTH-1:0] read_addres_mem;
  logic [FEATURE_WIDTH - 1:0] feature_matrix_mem [0:FEATURE_ROWS - 1][0:FEATURE_COLS - 1];
  logic [WEIGHT_WIDTH - 1:0] weight_matrix_mem [0:WEIGHT_COLS - 1][0:WEIGHT_ROWS - 1];
  logic [COO_BW - 1:0] coo_matrix_mem [0:COO_NUM_OF_ROWS - 1][0:COO_NUM_OF_COLS - 1];
  logic [COO_BW - 1:0] col_address;

  logic [DOT_PROD_WIDTH - 1:0] fm_wm_out_TB [0:FEATURE_ROWS-1][0:WEIGHT_COLS-1];
  logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer_final [0:FEATURE_ROWS - 1];
  logic [MAX_ADDRESS_WIDTH - 1:0] gold_output_addr [0:FEATURE_ROWS - 1];


  initial $readmemb(feature_filename, feature_matrix_mem);
  initial $readmemb(weight_filename, weight_matrix_mem);
  initial $readmemb(coo_filename, coo_matrix_mem);
  initial $readmemb(gold_address_filename, gold_output_addr);


always @(read_addres_mem or read_enable) begin
	if (read_enable) begin
		if(read_addres_mem >= 10'b10_0000_0000) begin
			input_data = feature_matrix_mem[read_addres_mem - 10'b10_0000_0000];
		end 
		else begin
			input_data = weight_matrix_mem[read_addres_mem];
		end 
	end
end 

	logic clk;		// Clock
	logic rst;		// Dut Reset
	logic start;		// Start Signal: This is asserted in the testbench
	logic done;		// All the Calculations are done

	// Clock Generator
        initial begin
            clk <= '0;
            forever #(HALF_CLOCK_CYCLE) clk <= ~clk;
        end



	initial begin 
		#100000;
		$display("Simulation Time Expired");
		
      	    foreach (fm_wm_out_TB[row, col]) begin
              $display("fm_row_out_TB[%0d][%0d] = %0d", row, col, 	 					fm_wm_out_TB[row][col]);
    		end
		$display("\n");
      	$finish;
	end 

	initial begin
		start = 1'b0;
		rst = 1'b1;
		// Reset the DUT
		repeat(3) begin
			#HALF_CLOCK_CYCLE;
			rst = ~rst;
		end
                start = 1'b1;

		wait (done === 1'b1);
		#21
		$finish;
 	end


Transformation_block TB_DUT
(
  .clk(clk),
  .reset(rst),
  .start(start),
  .data_in(input_data),
  //.fm_row_out(fm_wm_out_TB),
  .read_address(read_addres_mem),
  .enable_read(read_enable),
  .done(done)
);
  
endmodule