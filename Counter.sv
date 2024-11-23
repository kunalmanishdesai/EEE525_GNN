// Code your design here
module Counter #(
    parameter int START_COUNT = 0,
    parameter int LAST_COUNT = 2 // Default maximum count is 3
) (
    input logic clk,
    input logic reset,
    input logic enable_counter,
    output logic [$clog2(LAST_COUNT+1)-1:0] counter
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= START_COUNT; // Reset counter to 0
        end else if (enable_counter) begin
            if (counter == LAST_COUNT) begin
                counter <= START_COUNT; // Reset counter when it reaches LAST_COUNT
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

endmodule