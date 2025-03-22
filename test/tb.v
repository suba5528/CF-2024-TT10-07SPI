`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module spi_tb;

  // Dump the signals to a VCD file for waveform analysis
  initial begin
    $dumpfile("spi_tb.vcd");
    $dumpvars(0, spi_tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the SPI module (Replace `spi` with your actual module name)
  spi user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  // Generate clock signal for the simulation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Test sequence
  initial begin
      // Initialize inputs
      rst_n = 0;
      ena = 0;
      ui_in = 8'b00000000;
      uio_in = 8'b00000000;
      
      #10 rst_n = 1; // Release reset after 10 time units
      ena = 1;

      // SPI communication simulation
      #10 ui_in = 8'b10101010;  // Example data transmission
      #10 ui_in = 8'b01010101;
      #10 ui_in = 8'b11001100;
      #10 ui_in = 8'b00110011;

      // Finish the test after some time
      #100 $finish;
  end

endmodule
