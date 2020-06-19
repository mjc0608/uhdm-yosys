module top(
    input  wire A_CLK,
    input  wire A_RST,
    input  wire A_D,
    output wire A_Q,

    (* clkbuf_inhibit *)
    input  wire B_CLK,
    (* clkbuf_inhibit *)
    input  wire B_RST,
    input  wire B_D,
    output wire B_Q,
);

    // A
    reg A;
    always @(posedge A_CLK or posedge A_RST)
        if (A_RST) A <= 1'b0;
        else       A <= A_D;
    assign A_Q = A;

    // B
    reg B;
    always @(posedge B_CLK or posedge B_RST)
        if (B_RST) B <= 1'b0;
        else       B <= B_D;
    assign B_Q = B;

endmodule
