/**
 * Round function del round 14: funzione f(R, K)
 *
 * Utilizza R13 del round precedente e K14
 * per calcolare il valore (facendo lo XOR con L13) di R14.
*/

module f_k14(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K14;
    k14 k14_inst(
        .out(K14[48:1])
    );

    f f_inst_14(
        .R(R[32:1]),
        .K(K14[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
