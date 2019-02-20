/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

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

