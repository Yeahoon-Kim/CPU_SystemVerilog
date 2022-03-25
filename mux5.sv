module mux5(
  input logic [4:0] iA,
  input logic [4:0] iB,
  input logic iF,
  output logic [4:0] oY
);
  always_comb 
    case(iF)
      1'b0: oY = iA; 
      1'b1: oY = iB;
      default: oY = 5'b00000;
    endcase
endmodule