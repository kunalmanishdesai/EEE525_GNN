module COO_BLOCK(
	input logic clk,
	input logic rst,
	input logic [2:0] coo_in [0:1],
	input logic done_trans,
	input logic [15:0] row_data [0:2],
	input logic [2:0] read_row,
	
	output logic [2:0] coo_add,
	output logic done_comb,
	output logic [2:0] read_fm_wm_row,
	output logic [15:0] adj_fm_wm_row [0:2]
);
	
	logic [15:0] out [0:2];
	logic enable_counter;
	logic enable_write_fm_wm_prod;
	logic [2:0] node1;

	COO_FSM coo (
		.clk(clk),
		.reset(rst),
		.start(done_trans),
		.counter(coo_add),
		.coo_in(coo_in),
		.read_row(read_row),
		.node1(node1),
		.node2(read_fm_wm_row),
		.done(done_comb),
		.enable_counter(enable_counter),
		.enable_write_fm_wm_prod(enable_write_fm_wm_prod)
	);
	
	Matrix_FM_WM_ADJ_Memory write_fm_2(
		.clk(clk),
		.rst(rst),
		.write_row(node1),
		.read_row(node1),
		.wr_en(enable_write_fm_wm_prod),
		.fm_wm_adj_row_in(out),
		.fm_wm_adj_out(adj_fm_wm_row)
	);

	Row_Adder row_adder(
		.row1(adj_fm_wm_row),
		.row2(row_data),
		.out(out)
	);

	Counter #(
		.START_COUNT(0),
		.LAST_COUNT(6)
	)
	
	coo_address_counter(
        	.clk(clk),
        	.reset(rst),
        	.enable_counter(enable_counter),
        	.counter(coo_add)
    	);

	
	
	
endmodule
