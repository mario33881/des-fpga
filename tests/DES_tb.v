

module DES_tb;

    reg [64:1] in;
    wire [64:1] out;

    DES des(
        .in(in[64:1]),
        .out(out[64:1])
    );

    initial begin
        in = #10 64'b0111010001100101011100110111010001100011011010010110000101101111;

        in = #50 64'b0110010101110111011011110111011101100001011000100111011101101111;

        in = #50 64'b0111010001100101011100110111010001100011011010010110000101101111;

        $finish;
    end

    initial begin
        $dumpfile("DES_tb.vcd");
        $dumpvars;
    end
endmodule
