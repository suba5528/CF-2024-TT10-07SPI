<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

SPI (Serial Peripheral Interface) project implements a simple SPI Slave module that communicates with an SPI Master. The project involves receiving data from the master via MOSI, storing it, and sending it back via MISO. 

## How to test

1️⃣ Compile & Simulate using vivado.
2️⃣ Check Waveforms in gtkwave.
3️⃣ Run on Hardware (FPGA, or Arduino SPI).
4️⃣ Verify Communication using an SPI Master.

## External hardware

PMOD, LED .
