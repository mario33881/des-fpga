module FSMD_tb;

    reg [32:1] msg;
    reg ready_part1;
    reg ready_part2;
    reg clk;
    reg rst;

    wire [64:1] enc_msg;
    wire done;
    wire read_part1;

    FSMD fsmd_instance(
        .msg(msg[32:1]),
        .ready_part1(ready_part1),
        .ready_part2(ready_part2),
        .clk(clk),
        .rst(rst),

        .read_part1(read_part1),
        .enc_msg(enc_msg[64:1]),
        .done(done)
    );

    initial begin
        clk = 0;

        rst = #10 0;
        rst = #10 1;

        repeat(10000) begin
            clk = #10 !clk;
        end

        $display("not enough time!");
        $finish;
    end

    initial begin
        $dumpfile("FSMD_tb.vcd");
        $dumpvars;
    end

    initial begin
        msg = 0;
        ready_part1 = 0;
        ready_part2 = 0;

        msg = #50 32'b01110100011001010111001101110100;
        ready_part1 = #70 1;
        ready_part1 = #90 0;

        msg = #120 32'b01100011011010010110000101101111;
        ready_part2 = #140 1;
        ready_part2 = #160 0;

        #200 $display("first test done");

        msg = #50 32'b01110100011001010111001101110100;
        ready_part1 = #70 1;
        ready_part1 = #90 0;

        msg = #120 32'b01100011011010010110000101101111;
        ready_part2 = #140 1;
        ready_part2 = #160 0;

        #200 $display("seconds test done");

        $finish;
    end
endmodule
