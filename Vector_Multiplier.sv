module Vector_Multiplier (
    input logic [4:0] weight [95:0],  // Array of 96 elements, each 5 bits wide
    input logic [4:0] feature [95:0], // Array of 96 elements, each 5 bits wide
    output logic [15:0] partial_product  // Single output that sums the products, 14 bits wide
);

    // Temporary register to accumulate the sum of the products
    logic [15:0] product_sum;

    // Always block for combinational logic
    always_comb begin
        product_sum = 16'b0;  // Clear the sum before starting the new cycle (initial assignment)
        
        // Accumulate the product of weights and features
        for (integer i = 0; i < 96; i = i + 1) begin
            product_sum = product_sum + (weight[i] * feature[i]);  // Add the product to the sum
        end
    end

    // Assign the accumulated sum to the output
    assign partial_product = product_sum;

endmodule