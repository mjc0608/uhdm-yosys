package p;

typedef struct packed {
	byte a;
	byte b;
} p_t;

endpackage

module foo1
	import p::*;
(
	input p_t p
);

	p::p_t m;
	assign m = p;

endmodule

module top;

	p::p_t ps;
	assign ps.a = 8'hAA;
	assign ps.b = 8'h55;

	foo1 foo(.p(ps));
endmodule
