// This map translates internal FFs from Yosys to FDxx that can be found in the 7-Series FPGA fabric.

module  \$_DFF_N_   (input D, C, output Q);    FDRE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(1'b1), .R(1'b0)); endmodule
module  \$_DFF_P_   (input D, C, output Q);    FDRE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(1'b1), .R(1'b0)); endmodule

module  \$_DFFE_NP_ (input D, C, E, output Q); FDRE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(E),    .R(1'b0)); endmodule
module  \$_DFFE_PP_ (input D, C, E, output Q); FDRE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(E),    .R(1'b0)); endmodule

module  \$_DFF_NN0_ (input D, C, R, output Q); FDCE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(1'b1), .CLR(!R)); endmodule
module  \$_DFF_NP0_ (input D, C, R, output Q); FDCE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(1'b1), .CLR( R)); endmodule
module  \$_DFF_PN0_ (input D, C, R, output Q); FDCE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(1'b1), .CLR(!R)); endmodule
module  \$_DFF_PP0_ (input D, C, R, output Q); FDCE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(1'b1), .CLR( R)); endmodule

module  \$_DFF_NN1_ (input D, C, R, output Q); FDPE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(1'b1), .PRE(!R)); endmodule
module  \$_DFF_NP1_ (input D, C, R, output Q); FDPE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C(!C), .CE(1'b1), .PRE( R)); endmodule
module  \$_DFF_PN1_ (input D, C, R, output Q); FDPE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(1'b1), .PRE(!R)); endmodule
module  \$_DFF_PP1_ (input D, C, R, output Q); FDPE #(.INIT(|0)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .C( C), .CE(1'b1), .PRE( R)); endmodule

