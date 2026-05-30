
module crc_top_v2 #(
    parameter crc = 32,
    parameter poly = 32'hEDB88320,
    parameter n = 4,
    parameter residue = 32'h2144DF1C
) (
    input clk,
    input rst_n,
    input [n-1:0] data,
    input en_data,
    output reg correct
);

  wire [crc-1:0] lfsr_out;
  reg [n-1:0] data_reg;
  reg [crc-1:0] lfsr;
  reg en_lfsr;
  wire correct_wire;



  crc_comb #(
      .crc (crc),
      .poly(poly)
  ) uut (
      /*AUTOINST*/
      // Outputs
      .lfsr_out(lfsr_out[crc-1:0]),
      // Inputs
      .lfsr    (lfsr[crc-1:0]),
      .data_reg(data_reg[3:0])
  );


  // loading data.  rst not needed as initial does not matter
  always @(posedge clk) begin
    if (en_data) data_reg <= data;
  end


  //lfsr ff
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) lfsr <= {crc{1'b1}};
    else if (en_lfsr) lfsr <= lfsr_out;
  end

  // lfsr en ( 1 cycle delay after data loading  for the initial value(11111) of lfsr to undergo operation)

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) en_lfsr <= 0;
    else en_lfsr <= en_data;
  end

  // correct signal ff

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) correct <= 1'b0;
    else correct <= correct_wire;
  end


  assign correct_wire = (~lfsr == residue) ? 1'b1 : 1'b0;



endmodule

