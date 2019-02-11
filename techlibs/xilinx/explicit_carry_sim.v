`ifdef _EXPLICIT_CARRY

// Explicit carry chain primitives for VPR
module CARRY0(output CO_CHAIN, CO_FABRIC, O, input CI, CI_INIT, DI, S);
  parameter CYINIT_FABRIC = 0;
  wire CI_COMBINE;
  if(CYINIT_FABRIC) begin
    assign CI_COMBINE = CI_INIT;
  end else begin
    assign CI_COMBINE = CI;
  end
  assign CO_CHAIN = S ? CI_COMBINE : DI;
  assign CO_FABRIC = S ? CI_COMBINE : DI;
  assign O = S ^ CI_COMBINE;
endmodule

module CARRY(output CO_CHAIN, CO_FABRIC, O, input CI, DI, S);
  assign CO_CHAIN = S ? CI : DI;
  assign CO_FABRIC = S ? CI : DI;
  assign O = S ^ CI;
endmodule

`endif

