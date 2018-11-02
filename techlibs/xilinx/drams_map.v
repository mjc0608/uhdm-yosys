
`ifdef _EXPLICIT_DRAM

module RAM128X1S (
  output       O,
  input        D, WCLK, WE,
  input        A6, A5, A4, A3, A2, A1, A0
);
	parameter [127:0] INIT = 128'bx;
	parameter IS_WCLK_INVERTED = 0;
	wire low_lut_o6;
	wire high_lut_o6;

	wire [5:0] A = {A5, A4, A3, A2, A1, A0};

    // SPRAM128 is used here because RAM128X1S only consumes half of the
    // slice, but WA7USED is slice wide.  The packer should be able to pack two
    // RAM128X1S in a slice, but it should not be able to pack RAM128X1S and
    // a RAM64X1[SD]. It is unclear if RAM32X1[SD] or RAM32X2S can be packed
    // with a RAM128X1S, so for now it is forbidden.
    //
    // Note that a RAM128X1D does not require [SD]PRAM128 because it consumes
    // the entire slice.
	SPRAM128 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) low_ram (
		.DI1(D),
		.A(A),
		.WA7(A6),
		.CLK(WCLK),
		.WE(WE),
		.O6(low_lut_o6)
	);

	DPRAM128 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) high_ram (
		.DI1(D),
		.A(A),
		.WA(A),
		.WA7(A6),
		.CLK(WCLK),
		.WE(WE),
		.O6(high_lut_o6)
	);

	MUXF7 f7_mux (.O(O), .I0(low_lut_o6), .I1(high_lut_o6), .S(A6));
endmodule

module RAM128X1D (
  output       DPO, SPO,
  input        D, WCLK, WE,
  input  [6:0] A, DPRA
);
	parameter [127:0] INIT = 128'bx;
	parameter IS_WCLK_INVERTED = 0;
	wire dlut_o6;
	wire clut_o6;
	wire blut_o6;
	wire alut_o6;

	SPRAM64 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dlut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(dlut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) clut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(clut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) blut_ram (
		.DI1(D),
		.A(DPRA[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(blut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) alut_ram (
		.DI1(D),
		.A(DPRA[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(alut_o6)
	);


	MUXF7 f7b_mux (.O(SPO), .I0(dlut_o6), .I1(clut_o6), .S(A[6]));
	MUXF7 f7a_mux (.O(DPO), .I0(blut_o6), .I1(alut_o6), .S(DPRA[6]));
endmodule

module RAM256X1S (
  output       O,
  input        D, WCLK, WE,
  input  [7:0] A
);
	parameter [256:0] INIT = 256'bx;
	parameter IS_WCLK_INVERTED = 0;
	wire dlut_o6;
	wire clut_o6;
	wire blut_o6;
	wire alut_o6;
	wire f7b_o;
	wire f7a_o;

	SPRAM64 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dlut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA7(A[6]),
		.WA8(A[7]),
		.CLK(WCLK),
		.WE(WE),
		.O6(dlut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) clut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.WA8(A[7]),
		.CLK(WCLK),
		.WE(WE),
		.O6(clut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[191:128]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) blut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.WA8(A[7]),
		.CLK(WCLK),
		.WE(WE),
		.O6(blut_o6)
	);

	DPRAM64 #(
		.INIT(INIT[255:192]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) alut_ram (
		.DI1(D),
		.A(A[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.WA8(A[7]),
		.CLK(WCLK),
		.WE(WE),
		.O6(alut_o6)
	);

	MUXF7 f7b_mux (.O(f7b_o), .I0(dlut_o6), .I1(clut_o6), .S(A[6]));
	MUXF7 f7a_mux (.O(f7a_o), .I0(blut_o6), .I1(alut_o6), .S(A[6]));
	MUXF8 f8_mux (.O(O), .I0(f7b_o), .I1(f7a_o), .S(A[7]));
endmodule

module RAM32X1D (
  output DPO, SPO,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4
);
	parameter [31:0] INIT = 32'bx;
	parameter IS_WCLK_INVERTED = 0;

	wire [4:0] WA = {A5, A4, A3, A2, A1, A0};
	wire [4:0] DPRA = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};

	SPRAM32 #(
		.INIT_00(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_S (
		.DI1(D),
		.A(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(SPO)
	);
	DPRAM32 #(
		.INIT_00(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_D (
		.DI1(D),
		.A(DPRA),
		.WA(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(DPO)
	);
endmodule

module RAM32X1S (
  output O,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4
);
	parameter [31:0] INIT = 32'bx;
	parameter IS_WCLK_INVERTED = 0;

	SPRAM32 #(
		.INIT_00(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_S (
		.DI1(D),
		.A({A4, A3, A2, A1, A0}),
		.CLK(WCLK),
		.WE(WE),
		.O6(O)
	);
endmodule

module RAM32X2S (
  output O0, O1,
  input  D0, D1, WCLK, WE,
  input  A0, A1, A2, A3, A4
);
	parameter [31:0] INIT_00 = 32'bx;
	parameter [31:0] INIT_01 = 32'bx;
	parameter IS_WCLK_INVERTED = 0;

	SPRAM32 #(
		.INIT_00(INIT_00),
		.INIT_01(INIT_01),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_S (
		.DI1(D0),
		.DI2(D1),
		.A({A4, A3, A2, A1, A0}),
		.CLK(WCLK),
		.WE(WE),
		.O5(O1),
		.O6(O0)
	);
endmodule

module RAM64X1D (
  output DPO, SPO,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4, A5,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5
);
	parameter [63:0] INIT = 64'bx;
	parameter IS_WCLK_INVERTED = 0;

	wire [5:0] WA = {A5, A4, A3, A2, A1, A0};
	wire [5:0] DPRA = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};

	SPRAM64 #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_S (
		.DI1(D),
		.A(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(SPO)
	);
	DPRAM64 #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_D (
		.DI1(D),
		.A(DPRA),
		.WA(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(DPO)
	);
endmodule

module RAM64X1S (
  output O,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4, A5
);
	parameter [63:0] INIT = 64'bx;
	parameter IS_WCLK_INVERTED = 0;

	SPRAM64 #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram_S (
		.DI1(D),
		.A({A5, A4, A3, A2, A1, A0}),
		.CLK(WCLK),
		.WE(WE),
		.O6(O)
	);
endmodule

`endif

module \$__XILINX_RAM64X1D (CLK1, A1ADDR, A1DATA, B1ADDR, B1DATA, B1EN);
	parameter [63:0] INIT = 64'bx;
	parameter CLKPOL2 = 1;
	input CLK1;

	input [5:0] A1ADDR;
	output A1DATA;

	input [5:0] B1ADDR;
	input B1DATA;
	input B1EN;

	RAM64X1D #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(!CLKPOL2)
	) _TECHMAP_REPLACE_ (
		.DPRA0(A1ADDR[0]),
		.DPRA1(A1ADDR[1]),
		.DPRA2(A1ADDR[2]),
		.DPRA3(A1ADDR[3]),
		.DPRA4(A1ADDR[4]),
		.DPRA5(A1ADDR[5]),
		.DPO(A1DATA),

		.A0(B1ADDR[0]),
		.A1(B1ADDR[1]),
		.A2(B1ADDR[2]),
		.A3(B1ADDR[3]),
		.A4(B1ADDR[4]),
		.A5(B1ADDR[5]),
		.D(B1DATA),
		.WCLK(CLK1),
		.WE(B1EN)
	);
endmodule

module \$__XILINX_RAM128X1D (CLK1, A1ADDR, A1DATA, B1ADDR, B1DATA, B1EN);
	parameter [127:0] INIT = 128'bx;
	parameter CLKPOL2 = 1;
	input CLK1;

	input [6:0] A1ADDR;
	output A1DATA;

	input [6:0] B1ADDR;
	input B1DATA;
	input B1EN;

	RAM128X1D #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(!CLKPOL2)
	) _TECHMAP_REPLACE_ (
		.DPRA(A1ADDR),
		.DPO(A1DATA),

		.A(B1ADDR),
		.D(B1DATA),
		.WCLK(CLK1),
		.WE(B1EN)
	);
endmodule

