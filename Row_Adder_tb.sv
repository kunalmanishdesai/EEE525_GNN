module Row_Adder_tb;

	logic [5:0] row1 [15:0];
	logic [5:0] row2 [15:0];
	logic [6:0] out [15:0];

	Row_Adder DUT (
		.row1(row1),
		.row2(row2),
		.out(out)
	);

	initial begin 
		for(integer i=0;i<16;i=i+1) begin
			row1[i] = 1;
			row2[i] = 2;
		end

		#100;
		for(integer i=0;i<16;i=i+1) begin
			$display("out[%0d] = %h", i, out[i]);
		end
		$finish;
	end

endmodule
