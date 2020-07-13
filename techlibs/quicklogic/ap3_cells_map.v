module \$lut (A, Y);
    parameter WIDTH = 0;
    parameter LUT = 0;

    input [WIDTH-1:0] A;
    output Y;

    function [WIDTH ** 2 - 1:0] INIT_address_inverse;
        input [WIDTH ** 2 - 1: 0] arr;
        integer i;
        integer n;
        reg [WIDTH - 1:0] tmp;
        reg [WIDTH - 1:0] tmp2;
        tmp = 0;
        tmp2 = 0;
        for (i = 0; i < WIDTH ** 2; i++) begin
            INIT_address_inverse[tmp2] = arr[tmp];
            tmp = tmp + 1;
            for (n = 0; n < WIDTH; n++) begin
                tmp2[WIDTH - 1 - n] = tmp[n];
            end
        end
    endfunction

    generate
        if (WIDTH == 1)
        begin
            LUT4 #(.INIT(INIT_address_inverse(LUT))) _TECHMAP_REPLACE_ (.O(Y), .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(A[0]));
        end
        else if (WIDTH == 2)
        begin
            LUT4 #(.INIT(INIT_address_inverse(LUT))) _TECHMAP_REPLACE_ (.O(Y), .I0(1'b0), .I1(1'b0), .I2(A[1]), .I3(A[0]));
        end
        else if (WIDTH == 3)
        begin
            LUT4 #(.INIT(INIT_address_inverse(LUT))) _TECHMAP_REPLACE_ (.O(Y), .I0(1'b0), .I1(A[2]), .I2(A[1]), .I3(A[0]));
        end
        else if (WIDTH == 4)
        begin
            LUT4 #(.INIT(INIT_address_inverse(LUT))) _TECHMAP_REPLACE_ (.O(Y), .I0(A[3]), .I1(A[2]), .I2(A[1]), .I3(A[0]));
        end
        else
        begin
            wire _TECHMAP_FAIL_ = 1;
        end
    endgenerate
endmodule

module \$_DFF_ (D, CQZ, QCK, QEN, QRT, QST);
    input D;
    input QCK;
    input QEN;
    input QRT;
    input QST;
    output CQZ;
    ff _TECHMAP_REPLACE_ (.CQZ(CQZ), .D(D), .QCK(QCK), .QEN(QEN), .QRT(QRT), .QST(QST));
endmodule

module \$_DFF_N_ (D, Q, C);
    input D;
    input C;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(1'b0), .QST(1'b0));
endmodule

module \$_DFF_P_ (D, Q, C);
    input D;
    input C;
    output Q;
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(1'b0), .QST(1'b0));
endmodule

module \$_DFF_NN0_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    wire R_INV;
    inv clrinv (.Q(R_INV), .A(R));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(R_INV), .QST(1'b0));
endmodule

module \$_DFF_NN1_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    wire R_INV;
    inv preinv (.Q(R_INV), .A(R));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(1'b0), .QST(R_INV));
endmodule

module \$_DFF_NP0_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(R), .QST(1'b0));
endmodule

module \$_DFF_NP1_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(1'b0), .QST(R));
endmodule

module \$_DFF_PN0_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire R_INV;
    inv preinv (.Q(R_INV), .A(R));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(R_INV), .QST(1'b0));
endmodule

module \$_DFF_PN1_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    wire R_INV;
    inv preinv (.Q(R_INV), .A(R));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(1'b0), .QST(R_INV));
endmodule

module \$_DFF_PP0_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(R), .QST(1'b0));
endmodule

module \$_DFF_PP1_ (D, Q, C, R);
    input D;
    input C;
    input R;
    output Q;
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(1'b0), .QST(R));
endmodule

module \$_DFFSR_NPP_ (D, Q, C, R, S);
    input D;
    input C;
    input R;
    input S;
    output Q;
    wire C_INV;
    inv clkinv (.Q(C_INV), .A(C));
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C_INV), .QEN(1'b1), .QRT(R), .QST(S));
endmodule

module \$_DFFSR_PPP_ (D, Q, C, R, S);
    input D;
    input C;
    input R;
    input S;
    output Q;
    ff _TECHMAP_REPLACE_ (.CQZ(Q), .D(D), .QCK(C), .QEN(1'b1), .QRT(R), .QST(S));
endmodule

module RAM (RADDR,RRLSEL,REN,RMODE,
	    WADDR,WDATA,WEN,WMODE,
	    FMODE,FFLUSH,RCLK,WCLK,RDATA,
	    FFLAGS,FIFO_DEPTH,ENDIAN,POWERDN,PROTECT,
	    UPAE,UPAF,SBOG);

    input [10:0] RADDR,WADDR;
    input [1:0] 	RRLSEL,RMODE,WMODE;
    input 	REN,WEN,FFLUSH,RCLK,WCLK;
    input [31:0] WDATA;
    input [1:0] 	SBOG, ENDIAN, UPAF, UPAE;
    output [31:0] RDATA;
    output [3:0]  FFLAGS;
    input [2:0] 	 FIFO_DEPTH;
    input 	 FMODE, POWERDN, PROTECT;
   
    RAM _TECHMAP_REPLACE_ (
                .RADDR(RADDR),
                .RRLSEL(RRLSEL),
                .REN(REN),
                .RMODE(RMODE),
                .WADDR(WADDR),
                .WDATA(WDATA),
                .WEN(WEN),
                .WMODE(WMODE),
                .FMODE(FMODE),
                .FFLUSH(FFLUSH),
                .RCLK(RCLK),
                .WCLK(WCLK),
                .RDATA(RDATA),
                .FFLAGS(FFLAGS),
                .FIFO_DEPTH(FIFO_DEPTH),
                .ENDIAN(ENDIAN),
                .POWERDN(POWERDN),
                .PROTECT(PROTECT),
                .UPAE(UPAE),
                .UPAF(UPAF),
                .SBOG(SBOG));

endmodule

module DSP (MODE_SEL,COEF_DATA,OPER_DATA,OUT_SEL,ENABLE,CLR,RND,SAT,CLOCK,MAC_OUT,CSEL,OSEL,SBOG);

    input [1:0] MODE_SEL,OUT_SEL;
    input [1:0] CSEL;
    input [1:0] OSEL;
    input [31:0] COEF_DATA,OPER_DATA;
    input ENABLE,CLR,RND,SAT,CLOCK;
    input [1:0]SBOG;
    output [63:0] MAC_OUT;

    DSP _TECHMAP_REPLACE_ (
                .MODE_SEL(MODE_SEL),
                .COEF_DATA(COEF_DATA),
                .OPER_DATA(OPER_DATA),
                .OUT_SEL(OUT_SEL),
                .ENABLE(ENABLE),
                .CLR(CLR),
                .RND(RND),
                .SAT(SAT),
                .CLOCK(CLOCK),
                .MAC_OUT(MAC_OUT),
                .CSEL(CSEL),
                .OSEL(OSEL),
                .SBOG(SBOG));
                
endmodule