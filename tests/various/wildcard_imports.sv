package p;

typedef struct packed {
	byte a;
	byte b;
} p_t;

endpackage

module top;

	import p::*;
	p_t ps;
	assign ps.a = 8'hAA;
	assign ps.b = 8'h55;

endmodule
