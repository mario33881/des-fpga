/**
 * Round function del round 15: funzione f(R, K)
 *
 * Utilizza R14 del round precedente e K15
 * per calcolare il valore (facendo lo XOR con L14) di R15.
*/

module f_k15(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K15;
    k15 k15_inst(
        .out(K15[48:1])
    );

    f f_inst_15(
        .R(R[32:1]),
        .K(K15[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
