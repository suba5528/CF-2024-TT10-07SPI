`timescale 1ns / 1ps
`default_nettype none

module spi_tb;
    // Declare inputs and outputs
    reg rs;              // Reset signal
    reg clock_in;        // Input clock
    reg mosi;            // Master-to-slave data
    wire miso;           // Slave-to-master data
    wire sclk;           // SPI clock
    reg cs;
    wire led;  

    // Instantiate the SPI module
    tt_um_suba uut (  // Ensure module name matches your design
        .rs(rs),
        .clock_in(clock_in),
        .mosi(mosi),
        .miso(miso),
        .sclk(sclk),
        .cs(cs),
        .led(led)
    );

    // Clock Generation
    initial begin
       clock_in = 0;
       forever #5 clock_in = ~clock_in; // Generate clock with 10ns period
    end

    // Dump signals for waveform analysis
    initial begin
        $dumpfile("test/spi_tb.vcd");  // Ensure it saves to the correct directory
        $dumpvars(0, spi_tb);
    end

    // Test sequence
    initial begin
        rs = 1;     // Reset active
        cs = 1;     // Chip select inactive
        mosi = 0;   // Default state

        #10 rs = 0; // Release reset

        // Begin SPI communication
        #10 cs = 0; // Enable SPI slave
        #20 mosi = 1;
        #10 mosi = 0;
        #10 mosi = 1;
        #10 mosi = 0;
        #10 mosi = 1;
        #10 mosi = 1;
        #10 mosi = 0;
        #10 mosi = 0;
        #20 cs = 1; // Disable SPI slave

        // Finish Simulation
        #100;
        $finish;
    end

    // Monitor SPI transactions
    initial begin
        $monitor("Time=%0t | RS=%b | Clock=%b | MOSI=%b | MISO=%b | SCLK=%b | CS=%b",
                 $time, rs, clock_in, mosi, miso, sclk, cs);
    end
endmodule
