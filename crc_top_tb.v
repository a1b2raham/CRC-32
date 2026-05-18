`timescale 1ns / 1ps


module crc_top_tb;

  localparam crc = 32;
  localparam poly = 32'hEDB88320;
  localparam n = 4;
  localparam residue = 32'h2144DF1C;
  localparam data_size = 32;


  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire correct;  // From uut of crc_top.v
  // End of automatics

  /*AUTOREGINPUT*/
  // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
  reg clk;  // To uut of crc_top.v
  reg [n-1:0] data;  // To uut of crc_top.v
  reg en_data;  // To uut of crc_top.v
  reg rst_n;  // To uut of crc_top.v
  // End of automatics

  reg [data_size-1:0] temp_reg = 32'h12345678;  // input 32 bit data



  reg [7:0] byte_reg;
  integer i;
  crc_top #(
      .crc(crc),
      .poly(poly),
      .n(n),
      .residue(residue)
  ) uut (

      /*AUTOINST*/
      // Outputs
      .correct(correct),
      // Inputs
      .clk    (clk),
      .rst_n  (rst_n),
      .data   (data[n-1:0]),
      .en_data(en_data)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("crc_top_tb.vcd");
    $dumpvars(0, crc_top_tb);

    rst_n   = 1;
    en_data = 0;
    #2 rst_n = 0;
    #2 rst_n = 1;

    @(negedge clk);
    en_data = 1;

    // byte sized data
    for (i = 0; i < (data_size / 8); i = i + 1) begin
      byte_reg = temp_reg[(data_size-1)-8*i-:8];
      data = byte_reg[3:0];
      @(negedge clk);
      data = byte_reg[7:4];
      @(negedge clk);
    end

    en_data = 0;
    repeat (2) @(posedge clk);  // en_lfsr to go low


    $display("lfsr= %h ", ~(uut.lfsr));

    #30 $finish;

  end

endmodule
