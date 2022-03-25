/**
 * Round function del round 13: funzione f(R, K)
 *
 * Utilizza R12 del round precedente e K13
 * per calcolare il valore (facendo lo XOR con L12) di R13.
*/

module f_k13(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K13;
    k13 k13_inst(
        .out(K13[48:1])
    );

    f f_inst_13(
        .R(R[32:1]),
        .K(K13[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
