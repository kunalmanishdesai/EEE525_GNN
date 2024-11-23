
module ArgMaxBlock(
	input logic clk,
	input logic enable,
	input logic reset,
	input logic [15:0] row [0:2],
	output logic [1:0] out [0:5],
	output logic [2:0] read_row,
	output logic done
);
	
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			for (integer i = 0; i < 6; i = i + 1) begin
				out[i] <= 0;
			end
			read_row <= 0;
			done <= 0;
		end else if (enable && !done) begin
			read_row <= read_row + 1;

			if (row[0] >= row[1] && row[0] >= row[2]) begin
				out[read_row] <= 0;
			end else if (row[1] >= row[0] && row[1] >= row[2]) begin
				out[read_row] <= 1;
			end else begin
				out[read_row] <= 2;
			end
			
			if (read_row == 6) begin
				done <= 1;
			end
		end 
	end
endmodule