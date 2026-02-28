/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_lditsche (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [11:0] r0 = {6'b0, ui_in[5:0] & {6{ui_in[6]}}};
    wire [11:0] r1 = {5'b0, ui_in[5:0] & {6{ui_in[7]}}, 1'b0};
    wire [11:0] r2 = {4'b0, ui_in[5:0] & {6{uio_in[0]}}, 2'b0};
    wire [11:0] r3 = {3'b0, ui_in[5:0] & {6{uio_in[1]}}, 3'b0};
    wire [11:0] r4 = {2'b0, ui_in[5:0] & {6{uio_in[2]}}, 4'b0};
    wire [11:0] r5 = {1'b0, ui_in[5:0] & {6{uio_in[3]}}, 5'b0};

    wire [11:0] s1, c1, s2, c2, s3, c3, s4, c4;
    wire [11:0] c1_shift, c2_shift, c3_shift, c4_shift;

    shift shiftward1 (.a(c1), .ashift(c1_shift));
    shift shiftward2 (.a(c2), .ashift(c2_shift));
    shift shiftward3 (.a(c3), .ashift(c3_shift));
    shift shiftward4 (.a(c4), .ashift(c4_shift));

    generate
        for (genvar i = 0; i < 12; i++) begin: sixtofour
            full_adder fa1 (.a(r0[i]), .b(r1[i]), .cin(r2[i]), .sum(s1[i]), .carry(c1[i]));
            full_adder fa2 (.a(r3[i]), .b(r4[i]), .cin(r5[i]), .sum(s2[i]), .carry(c2[i]));
        end
    endgenerate

    generate
        for (genvar i = 0; i < 12; i++) begin: fourtothree
            full_adder fa3 (.a(s1[i]), .b(c1_shift[i]), .cin(s2[i]), .sum(s3[i]), .carry(c3[i]));
        end
    endgenerate

    generate
        for (genvar i = 0; i < 12; i++) begin: threetotwo
            full_adder fa4 (.a(s3[i]), .b(c3_shift[i]), .cin(c2_shift[i]), .sum(s4[i]), .carry(c4[i]));
        end
    endgenerate
    
    wire [11:0] P;
    assign P = s4 + c4_shift;
    assign uio_out[7:4] = P[11:8];
    assign uio_out[3:0] = 0;
    assign uo_out = P[7:0];
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_oe = 8'b11110000;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
