"""
GEN_FK: generates f(r, k) functions.
"""

fk = """
module f_k{}(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K{};
    k{} k{}_inst(
        .out(K{}[48:1])
    );

    f f_inst_{}(
        .R(R[32:1]),
        .K(K{}[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
"""

for i in range(1, 17):
    with open(f"f_k{i}.v", "w") as f:
        f.write(fk.format(i,i,i,i,i,i,i) + "\n")
