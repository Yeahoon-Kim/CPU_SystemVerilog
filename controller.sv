module controller(
  input logic [5:0] iOp,
  input logic [5:0] iFunct,
  output logic oRegWrite,
  output logic oMemWrite,
  output logic oRegDst,
  output logic oALUSrc,
  output logic oMemToReg,
  output logic [2:0] oALUControl
);
  logic [1:0] aluop;
  
  always_comb
    case(iOp)
      6'b100011: begin // lw
        oRegWrite = 1'b1;
        oRegDst = 1'b0;
        oALUSrc = 1'b1;
        oMemWrite = 1'b0;
        oMemToReg = 1'b1;
        aluop = 2'b00;
      end
      6'b101011: begin // sw
        oRegWrite = 1'b0;
        oALUSrc = 1'b1;
        oMemWrite = 1'b1;
        aluop = 2'b00;
      end
      6'b000000: begin // R-type
        oRegWrite = 1'b1;
        oRegDst = 1'b1;
        oALUSrc = 1'b0;
        oMemWrite = 1'b0;
        oMemToReg = 1'b0;
        aluop = 2'b10;
      end
      default: begin   // Default
        oRegWrite = 1'b0;
        oMemWrite = 1'b0;
        aluop = 2'b00;
      end
    endcase
  
  always_comb
    case(aluop)
      2'b00: oALUControl = 3'b010;
      2'b10: begin // R-type
        case(iFunct)
          6'b100000: oALUControl = 3'b010; // add
          6'b100010: oALUControl = 3'b110; // sub
          6'b100100: oALUControl = 3'b000; // and
          6'b100101: oALUControl = 3'b001; // or
          6'b101010: oALUControl = 3'b111; // SLT
        endcase
      end
      default: oALUControl = 3'b000;
    endcase
endmodule
 
  