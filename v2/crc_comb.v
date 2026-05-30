module crc_comb #(
    parameter crc  = 32,
    parameter poly = 32'hEDB88320
) (
    input [crc-1:0] lfsr,
    input [3:0] data_reg,
    output [crc-1 : 0] lfsr_out
);

  wire t0, t1, t2, t3;
  wire [crc-1:0] d0, d1, d2, d3;



  assign t0 = data_reg[0] ^ lfsr[0];
  assign t1 = data_reg[1] ^ lfsr[1];
  assign t2 = data_reg[2] ^ lfsr[2];
  assign t3 = data_reg[3] ^ lfsr[3];


  assign d0 = poly & {crc{t0}};
  assign d1 = poly & {crc{t1}};
  assign d2 = poly & {crc{t2}};
  assign d3 = poly & {crc{t3}};

  assign lfsr_out = ({4'b0,lfsr[crc-1:4]}) ^ ({3'b0,d0[crc-1:3]}) ^ ({2'b0,d1[crc-1:2]}) ^ ({1'b0,d2[crc-1:1]}) ^ d3;







endmodule
