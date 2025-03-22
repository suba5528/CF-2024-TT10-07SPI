/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`timescale 1ns / 1ps

module tt_um_suba (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // SPI signal assignments
    wire rs     = ui_in[0]; // Reset signal
    wire cs     = ui_in[1]; // Chip select
    wire mosi   = ui_in[2]; // SPI MOSI (Master Out, Slave In)
    wire clock_in = clk;    // System clock input

    reg [7:0] received_data;  // Data received from MOSI
    reg [7:0] transmit_data = 8'b10101001; // Data to send via MISO
    reg [2:0] state_mosi;     // State machine for MOSI
    reg [2:0] state_miso;     // State machine for MISO
    reg [3:0] mosi_counter;
    reg [3:0] miso_counter;
    reg miso_out;

    // SPI Clock Divider (Generates SPI Clock)
    reg [25:0] count = 0;
    reg clk_out;
    always @(posedge clock_in) begin
        count <= count + 1;
        if (count == 50_000_000) begin
            count <= 0;
            clk_out = ~clk_out;
        end
    end

    assign uo_out[1] = clk_out;  // LED Output
    assign uo_out[0] = miso_out; // MISO Output
    assign uo_out[2] = clk_out;  // SPI Clock Output (sclk)
    assign uo_out[7:3] = 0;      // Unused outputs set to 0

    // All unused IOs are set to 0 to avoid warnings
    assign uio_out = 0;
    assign uio_oe  = 0;
    wire _unused = &{ena, ui_in[7:3], uio_in[7:0]};

    // MOSI State Machine (Receiving Data)
    always @(negedge clk_out) begin
        if (!rst_n) begin
            received_data <= 0;
            state_mosi <= 0;
            mosi_counter <= 7;
        end else begin
            case(state_mosi)
                0: if (!cs) state_mosi <= 1;
                1: if (!cs) begin
                        state_mosi <= 2;
                        mosi_counter <= 7;
                   end
                2: begin
                    received_data[mosi_counter] <= mosi;
                    if (mosi_counter == 0) state_mosi <= 3;
                    mosi_counter <= mosi_counter - 1;
                   end
                3: state_mosi <= 0;
            endcase
        end
    end

    // MISO State Machine (Transmitting Data)
    always @(posedge clk_out) begin
        if (!rst_n) begin
            state_miso <= 0;
            miso_counter <= 7;
            miso_out <= 1;
        end else begin
            case(state_miso)
                0: if (!cs) state_miso <= 1;
                1: begin
                    miso_out <= 0;
                    state_miso <= 2;
                    miso_counter <= 7;
                   end
                2: begin
                    miso_out <= transmit_data[miso_counter];
                    if (miso_counter == 0) state_miso <= 3;
                    miso_counter <= miso_counter - 1;
                   end
                3: begin
                    miso_out <= 1;
                    state_miso <= 0;
                   end
            endcase
        end
    end

endmodule
