module mux32(
  input logic [31:0] iA,
  input logic [31:0] iB,
  input logic iF,
  output logic [31:0] oY
);
  always_comb 
    case(iF)
      1'b0: oY = iA; 
      1'b1: oY = iB;
      default: oY = 8'h00000000;
    endcase
endmodule