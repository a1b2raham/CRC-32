`include "unit.v"


module nbit_unit #(
    parameter crc = 32,
    parameter poly = 32'hEDB88320,
    parameter n = 4
) (

    input  [crc-1:0] in_reg,
    input  [  n-1:0] data,
    output [crc-1:0] out_reg
);

  wire [crc-1:0] inter[n:0];

  assign inter[0] = in_reg;


  genvar i;

  generate

    for (i = 0; i < n; i = i + 1) begin

      unit #(
          .crc (crc),
          .poly(poly)
      ) i_unit (
          .data_in(data[i]),
          .in_reg (inter[i]),
          .out_reg(inter[i+1])
      );


    end

  endgenerate


  assign out_reg = inter[n];



endmodule
