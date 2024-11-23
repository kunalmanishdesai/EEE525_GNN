module Counter_tb;

    // Parameters
    parameter int LAST_COUNT = 6;

    // Signals
    logic clk;
    logic reset;
    logic enable_counter;
    logic [$clog2(LAST_COUNT+1)-1:0] counter;

    // Instantiate the DUT (Device Under Test)
    Counter #(
	//.START_COUNT(1),
	.LAST_COUNT(LAST_COUNT)) dut (
        .clk(clk),
        .reset(reset),
        .enable_counter(enable_counter),
        .counter(counter)
    );

    // Clock Generation: 50% duty cycle
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units period
    end

    // Stimulus
    initial begin
        // Initialize signals
        reset = 1;
        enable_counter = 0;

        // Apply reset
        #10 reset = 0;

        // Enable counter and run test
        enable_counter = 1;
        #50; // Let the counter run for a few clock cycles

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Reset: %b | Enable: %b | Counter: %d", 
                 $time, reset, enable_counter, counter);
    end
endmodule