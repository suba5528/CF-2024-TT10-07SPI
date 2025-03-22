`default_nettype none
`timescale 1ns / 1ps

/* This testbench instantiates the SPI module and makes convenient wires
   that can be driven/tested by the cocotb test.py or any other simulator.
*/

module tb ();

  // Dump the signals to a VCD file for waveform viewing
 

  // Declare wires and regs
  reg clock_in;
  reg rs;
  reg mosi;
  reg cs;
  wire miso;
  wire sclk;
  wire led;

tt_um_suba sp_ins(
    .rs(ui_in[0]),          // Reset signal
    .clock_in(ui_in[1]),    // Clock input
    .mosi(ui_in[2]),        // MOSI line
    .miso(uo_out[0]),       // MISO output
    .led(uo_out[1]),        // LED output
    .sclk(uo_out[2]),       // SPI Clock output
    .cs(ui_in[3])           // Chip select input
);

  
  // Clock generation
  initial begin
    clock_in = 0;
    forever #5 clock_in = ~clock_in; // 100MHz clock
  end

  // Test sequence to simulate SPI transaction
  initial begin
    rs = 1;
    cs = 1;
    mosi = 0;
    #20 rs = 0; // De-assert reset

    // Start first SPI transaction
    #20 cs = 0; // Chip select active
    #20 mosi = 1;
    #20 mosi = 0;
    #20 mosi = 1;
    #20 mosi = 0;
    #20 mosi = 1;
    #20 mosi = 1;
    #20 mosi = 0;
    #20 mosi = 0;
    #20 cs = 1; // Chip select inactive

    // Wait and start second transaction
    #50;
    cs = 0;
    #20 mosi = 0;
    #20 mosi = 0;
    #20 mosi = 1;
    #20 mosi = 0;
    #20 mosi = 0;
    #20 mosi = 1;
    #20 mosi = 0;
    #20 mosi = 1;
    #20 cs = 1;

    // End simulation after some time
    #100 $finish;
  end
     initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

endmodule
