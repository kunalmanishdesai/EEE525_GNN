module Feature_Counter_tb;

    // Parameters
    parameter int LAST_COUNT = 3;

    // Signals
    logic clk;
    logic reset;
    logic enable_feature_counter;
    logic [$clog2(LAST_COUNT+1)-1:0] counter;

    // Instantiate the DUT (Device Under Test)
    Counter #(.LAST_COUNT(LAST_COUNT)) dut (
        .clk(clk),
        .reset(reset),
        .enable_counter(enable_feature_counter),
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
        enable_feature_counter = 0;

        // Apply reset
        #10 reset = 0;

        // Enable counter and run test
        enable_feature_counter = 1;
        #50; // Let the counter run for a few clock cycles

        // Apply reset during counting
        reset = 1;
        #10 reset = 0;
        #30;

        // Disable counter
        enable_feature_counter = 0;
        #20;

        // Re-enable counter
        enable_feature_counter = 1;
        #40;

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Reset: %b | Enable: %b | Counter: %d", 
                 $time, reset, enable_feature_counter, counter);
    end
