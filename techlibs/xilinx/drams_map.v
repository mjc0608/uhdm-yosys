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
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(0)
	) ram0 (
		.DI1(D),
		.A(A),
		.WA7(A6),
		.CLK(WCLK),
		.WE(WE),
		.O6(low_lut_o6)
	);

	DPRAM128 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(1)
	) ram1 (
		.DI1(D),
		.A(A),
		.WA(A),
		.WA7(A6),
		.CLK(WCLK),
		.WE(WE),
		.O6(high_lut_o6)
	);

	MUXF7 ram_f7_mux (.O(O), .I0(low_lut_o6), .I1(high_lut_o6), .S(A6));
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

	SPRAM128 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(0)
	) ram0 (
		.DI1(D),
		.A(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(dlut_o6)
	);

	DPRAM128 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(1)
	) ram1 (
		.DI1(D),
		.A(A[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(clut_o6)
	);

	DPRAM128 #(
		.INIT(INIT[63:0]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(0)
	) ram2 (
		.DI1(D),
		.A(DPRA[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(blut_o6)
	);

	DPRAM128 #(
		.INIT(INIT[127:64]),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.HIGH_WA7_SELECT(0)
	) ram3 (
		.DI1(D),
		.A(DPRA[5:0]),
		.WA(A[5:0]),
		.WA7(A[6]),
		.CLK(WCLK),
		.WE(WE),
		.O6(alut_o6)
	);

    wire SPO_FORCE;
    wire DPO_FORCE;

	MUXF7 f7b_mux (.O(SPO_FORCE), .I0(dlut_o6), .I1(clut_o6), .S(A[6]));
	MUXF7 f7a_mux (.O(DPO_FORCE), .I0(blut_o6), .I1(alut_o6), .S(DPRA[6]));

	DRAM_2_OUTPUT_STUB stub (
		.SPO(SPO_FORCE), .DPO(DPO_FORCE),
		.SPO_OUT(SPO), .DPO_OUT(DPO));
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
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.WA7USED(1),
		.WA8USED(1),
		.HIGH_WA7_SELECT(0),
		.HIGH_WA8_SELECT(0)
	) ram0 (
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
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.WA7USED(1),
		.WA8USED(1),
		.HIGH_WA7_SELECT(1),
		.HIGH_WA8_SELECT(0)
	) ram1 (
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
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.WA7USED(1),
		.WA8USED(1),
		.HIGH_WA7_SELECT(0),
		.HIGH_WA8_SELECT(1)
	) ram2 (
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
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED),
		.WA7USED(1),
		.WA8USED(1),
		.HIGH_WA7_SELECT(1),
		.HIGH_WA8_SELECT(1)
	) ram3 (
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

	wire [4:0] WA = {A4, A3, A2, A1, A0};
	wire [4:0] DPRA = {DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};

	wire SPO_FORCE, DPO_FORCE;

	SPRAM32 #(
		.INIT_00(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) ram0 (
		.DI1(D),
		.A(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(SPO_FORCE)
	);
	DPRAM32 #(
		.INIT_00(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) ram1 (
		.DI1(D),
		.A(DPRA),
		.WA(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(DPO_FORCE)
	);

	DRAM_2_OUTPUT_STUB stub (
		.SPO(SPO_FORCE), .DPO(DPO_FORCE),
		.SPO_OUT(SPO), .DPO_OUT(DPO));
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

module RAM32M (
  output [1:0] DOA, DOB, DOC, DOD,
  input [1:0] DIA, DIB, DIC, DID,
  input [4:0] ADDRA, ADDRB, ADDRC, ADDRD,
  input WE, WCLK
);
	parameter [63:0] INIT_A = 64'bx;
	parameter [63:0] INIT_B = 64'bx;
	parameter [63:0] INIT_C = 64'bx;
	parameter [63:0] INIT_D = 64'bx;


endmodule

//module RAM64M (
//  output DOA, DOB, DOC, DOD,
//  input DIA, DIB, DIC, DID,
//  input [5:0] ADDRA, ADDRB, ADDRC, ADDRD,
//  input WE, WCLK
//);
//	parameter [63:0] INIT_A = 64'bx;
//	parameter [63:0] INIT_B = 64'bx;
//	parameter [63:0] INIT_C = 64'bx;
//	parameter [63:0] INIT_D = 64'bx;
//	parameter IS_WCLK_INVERTED = 0;
//
//	parameter _TECHMAP_BITS_CONNMAP_ = 0;
//	parameter _TECHMAP_CONNMAP_DIA_ = 0;
//	parameter _TECHMAP_CONNMAP_DIB_ = 0;
//	parameter _TECHMAP_CONNMAP_DIC_ = 0;
//	parameter _TECHMAP_CONNMAP_DID_ = 0;
//	parameter _TECHMAP_CONNMAP_ADDRA_ = 0;
//	parameter _TECHMAP_CONNMAP_ADDRB_ = 0;
//	parameter _TECHMAP_CONNMAP_ADDRC_ = 0;
//	parameter _TECHMAP_CONNMAP_ADDRD_ = 0;
//
//	wire COMMON_DI_PORT = (_TECHMAP_CONNMAP_DIA_ == _TECHMAP_CONNMAP_DIB_) &
//		(_TECHMAP_CONNMAP_DIA_ == _TECHMAP_CONNMAP_DIB_) &
//		(_TECHMAP_CONNMAP_DIA_ == _TECHMAP_CONNMAP_DID_);
//
//	wire COMMON_ADDR_PORT = (_TECHMAP_CONNMAP_ADDRA_ == _TECHMAP_CONNMAP_ADDRB_) &
//		(_TECHMAP_CONNMAP_ADDRA_ == _TECHMAP_CONNMAP_ADDRC_) &
//		(_TECHMAP_CONNMAP_ADDRA_ == _TECHMAP_CONNMAP_ADDRD_);
//
//	wire DOD_TO_STUB;
//	wire DOC_TO_STUB;
//	wire DOB_TO_STUB;
//	wire DOA_TO_STUB;
//
//	wire GROUNDED_DID_PORT = (_TECHMAP_CONNMAP_DID_ == 0);
//
//	if(!GROUNDED_DID_PORT) begin
//		SPRAM64 #(
//			.INIT(INIT_D),
//			.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
//		) dram1 (
//			.DI1(DID_IN),
//			.A(ADDRD),
//			.CLK(WCLK),
//			.WE(WE),
//			.O6(DOD_TO_STUB)
//		);
//	end
//
//	if(!GROUNDED_DID_PORT) begin
//		DRAM_4_OUTPUT_STUB stub (
//			.DOD(DOD_TO_STUB), .DOD_OUT(DOD),
//			.DOC(DOC_TO_STUB), .DOC_OUT(DOC),
//			.DOB(DOB_TO_STUB), .DOB_OUT(DOB),
//			.DOA(DOA_TO_STUB), .DOA_OUT(DOA)
//		);
//	end else begin
//		DRAM_4_OUTPUT_STUB stub (
//			.DOC(DOC_TO_STUB), .DOC_OUT(DOC),
//			.DOB(DOB_TO_STUB), .DOB_OUT(DOB),
//			.DOA(DOA_TO_STUB), .DOA_OUT(DOA)
//		);
//	end
//endmodule

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
	wire SPO_FORCE, DPO_FORCE;

	SPRAM64 #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram1 (
		.DI1(D),
		.A(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(SPO_FORCE)
	);
	DPRAM64 #(
		.INIT(INIT),
		.IS_WCLK_INVERTED(IS_WCLK_INVERTED)
	) dram0 (
		.DI1(D),
		.A(DPRA),
		.WA(WA),
		.CLK(WCLK),
		.WE(WE),
		.O6(DPO_FORCE)
	);

	DRAM_2_OUTPUT_STUB stub (
		.SPO(SPO_FORCE), .DPO(DPO_FORCE),
		.SPO_OUT(SPO), .DPO_OUT(DPO));
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

// ============================================================================
// Dual port distributed RAMs

module \$__XILINX_RAM32X1D (CLK1, A1ADDR, A1DATA, B1ADDR, B1DATA, B1EN);
	parameter [31:0] INIT = 32'bx;

	input CLK1;

	input [4:0] A1ADDR;
	output A1DATA;

	input [4:0] B1ADDR;
	input B1DATA;
	input B1EN;

	RAM32X1D #(
		.INIT(INIT)
	) _TECHMAP_REPLACE_ (
		.DPRA0(A1ADDR[0]),
		.DPRA1(A1ADDR[1]),
		.DPRA2(A1ADDR[2]),
		.DPRA3(A1ADDR[3]),
		.DPRA4(A1ADDR[4]),
		.DPO(A1DATA),

		.A0(B1ADDR[0]),
		.A1(B1ADDR[1]),
		.A2(B1ADDR[2]),
		.A3(B1ADDR[3]),
		.A4(B1ADDR[4]),
		.D(B1DATA),
		.WCLK(CLK1),
		.WE(B1EN)
	);
endmodule

module \$__XILINX_RAM64X1D (CLK1, A1ADDR, A1DATA, B1ADDR, B1DATA, B1EN);
	parameter [63:0] INIT = 64'bx;

	input CLK1;

	input [5:0] A1ADDR;
	output A1DATA;

	input [5:0] B1ADDR;
	input B1DATA;
	input B1EN;

	RAM64X1D #(
		.INIT(INIT)
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

	input CLK1;

	input [6:0] A1ADDR;
	output A1DATA;

	input [6:0] B1ADDR;
	input B1DATA;
	input B1EN;

	RAM128X1D #(
		.INIT(INIT),
	) _TECHMAP_REPLACE_ (
		.DPRA(A1ADDR),
		.DPO(A1DATA),

		.A(B1ADDR),
		.D(B1DATA),
		.WCLK(CLK1),
		.WE(B1EN)
	);
endmodule

