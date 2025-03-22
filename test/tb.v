`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file for waveform viewing
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Declare wires and regs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the SPI module (tt_um_suba)
  tt_um_suba sp_ins (
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path
      .ena    (ena),      // Enable signal
      .clk    (clk),      // Clock
      .rst_n  (rst_n)     // Reset (active low)
  );

  // Clock generation (50 MHz)
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // Toggle clock every 10 time units
  end

  // Test sequence to simulate SPI transaction
  initial begin
    // Initialize Inputs
    rst_n = 1;      // Assert Reset
    ena = 1;        // Enable the module
    ui_in = 8'b00000000;  // Initialize input signals
    uio_in = 8'b00000000;
    
    #20 rst_n = 0;  // Reset goes low
    #20 rst_n = 1;  // Release Reset

    // Start first SPI transaction (CS low, sending data via MOSI)
    #20 ui_in[1] = 0; // CS low (active)
        ui_in[2] = 1; // MOSI bit 1
    #20 ui_in[2] = 0; // MOSI bit 2
    #20 ui_in[2] = 1; // MOSI bit 3
    #20 ui_in[2] = 0; // MOSI bit 4
    #20 ui_in[2] = 1; // MOSI bit 5
    #20 ui_in[2] = 1; // MOSI bit 6
    #20 ui_in[2] = 0; // MOSI bit 7
    #20 ui_in[2] = 0; // MOSI bit 8
    #20 ui_in[1] = 1; // CS high (end of transaction)

    // Wait and start second transaction
    #50;
    ui_in[1] = 0; // CS low
    #20 ui_in[2] = 0;
    #20 ui_in[2] = 0;
    #20 ui_in[2] = 1;
    #20 ui_in[2] = 0;
    #20 ui_in[2] = 0;
    #20 ui_in[2] = 1;
    #20 ui_in[2] = 0;
    #20 ui_in[2] = 1;
    #20 ui_in[1] = 1; // CS high

    // End simulation after some time
    #100 $finish;
  end

endmodule
