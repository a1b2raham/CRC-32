

module unit #(
    parameter crc  = 32,
    parameter poly = 32'hEDB88320
) (
    input data_in,
    input [crc-1:0] in_reg,
    output [crc-1:0] out_reg
);
  assign out_reg = (data_in ^ in_reg[crc-1]) ? ({in_reg[crc-2:0],1'b0} ^ poly) : {in_reg[crc-2:0],1'b0};





endmodule
