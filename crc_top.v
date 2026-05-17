`include "nbit_unit.v"



module crc_top #(
    parameter crc = 32,
    parameter poly = 32'hEDB88320,
    parameter n = 4,
    parameter residue = 32'h2144DF1C
) (
    input clk,
    input rst,
    input [n-1:0] data,
    input data_en,
    output reg correct
);

  wire [crc-1:0] lfsr_out;

  reg  [crc-1:0] lfsr;






  nbit_unit #(
      .crc(crc),
      .poly(poly),
      .n(n)
  ) uut (
      .in_reg(lfsr),
      .out_reg(lfsr_out),
      .data(data)
  );




  always @(posedge clk or posedge rst) begin
    if (rst) begin
      lfsr <= {crc{1'b1}};
      correct <= 1'b0;

    end else begin

      if (data_en) lfsr <= lfsr_out;
      else correct <= (~lfsr == residue);

    end  // else: !if(rst)

  end


endmodule

