
module Row_Adder (
    input logic [15:0] row1 [0:2],  // Array of 6 elements, each 5 bits wide
    input logic [15:0] row2 [0:2], // Array of 96 elements, each 5 bits wide
    output logic [15:0] out [0:2]  // Single output that sums the products, 14 bits wide
);

    // Always block for combinational logic
    always_comb begin
	for(integer i=0; i < 3; i=i+1) begin
		out[i] = row1[i] + row2[i];
	end
    end
endmodule