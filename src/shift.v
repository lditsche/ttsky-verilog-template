module shift(
    input [11:0] a,
    output [11:0] ashift
);
    assign ashift[0] = 1'b0;
    assign ashift[11:1] = a[10:0]; 
endmodule