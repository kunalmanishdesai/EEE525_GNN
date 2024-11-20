module Transformation_block#(
    parameter WEIGHT_COLS = 3,
    parameter WEIGHT_WIDTH = 6,
    parameter WEIGHT_ROWS = 96,
    parameter DOT_PROD_WIDTH = 16,
)(
    input logic clk,
    input logic reset,
    input logic start,
    input logic read_row,
    input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],

    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out  [0:WEIGHT_COLS-1]
);

    reg[2:0] weight_count;
    reg[3:0] feature_count;

    reg [4:0] weight [95:0];

    reg logic [DOT_PROD_WIDTH - 1:0] element;
    
    logic enable_feature_counter,enable_weight_counter;

    logic enable_read,enable_write,read_feature_or_weight, done;
    logic enable_scratch_pad;
    logic enable_write_fm_wm_prod;

    Counter #(.LAST_COUNT(2)) weight_counter_mod(
        .clk(clk),
        .reset(reset),
        .enable_counter(enable_weight_counter),
        .counter(weight_count)
    );

    Counter #(.LAST_COUNT(5)) feature_counter_mod(
        .clk(clk),
        .reset(reset),
        .enable_counter(enable_feature_counter),
        .counter(feature_count)
    );

    Transformation_FSM transformation_FSM(
        .clk(clk)
        .reset(reset)
        .weight_count(weight_count)
        .feature_count(feature_count)
        .enable_write_fm_wm_prod(enable_write_fm_wm_prod)
        .enable_read(enable_read)
        .enable_write(enable_write)
        .enable_scratch_pad(enable_scratch_pad)
        .enable_weight_counter(enable_weight_counter)
        .enable_feature_counter(enable_feature_counter)
        .read_feature_or_weight(read_feature_or_weight)
        .done(done)
    )

    Scratch_Pad(
        .clk(clk)
        .reset(reset)
        .write_enable(enable_scratch_pad)
        .weight_col_in(data_in)
        .weight_col_out(weight)
    )


    Vector_Multiplier vector_Multiplier(
        .weight(weight)
        .feature(data_in)
        .partial_product()
    )

    Matrix_FM_WM_Memory matrix_FM_WM_Memory(
        .clk(clk)
        .reset(reset)
        .write_row(feature_count)
        .write_col(weight_count)
        .read_row(read_row)
        .wr_en(enable_write_fm_wm_prod)
        .fm_wm_in(element)
        .fm_wm_row_out(fm_wm_row_out)
    )

endmodule