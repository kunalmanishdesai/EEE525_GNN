module Vector_Multiplier_tb;

    // Signals
    logic [4:0] weight [95:0];  // Array of 96 elements, each 5 bits wide
    logic [4:0] feature [95:0]; // Array of 96 elements, each 5 bits wide
    logic [15:0] partial_product;  // Output that holds the sum of products

    // Instantiate the DUT (Device Under Test)
    Vector_Multiplier dut (
        .weight(weight),
        .feature(feature),
        .partial_product(partial_product)
    );


    // Test stimulus
    initial begin
        // Declare a temporary variable for feature index increment
        logic [4:0] x;


        // Initialize weight and feature arrays with some values
        for (int i = 0; i < 96; i = i + 1) begin
            weight[i] = i;    // Set weight array values from 0 to 95
            x = i + 1;             // Temporary variable for feature increment
            feature[i] = x;   // Set feature array values from 1 to 96
        end

        // Let the simulation run for a few clock cycles
        #5;

        // Check the result after multiplication and accumulation
        $display("Accumulated partial_product: %d", partial_product);

        // Finish simulation
        $finish;
    end

endmodule