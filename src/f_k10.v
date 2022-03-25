/**
 * Round function del round 10: funzione f(R, K)
 *
 * Utilizza R9 del round precedente e K10
 * per calcolare il valore (facendo lo XOR con L9) di R10.
*/

module f_k10(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K10;
    k10 k10_inst(
        .out(K10[48:1])
    );

    f f_inst_10(
        .R(R[32:1]),
        .K(K10[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
