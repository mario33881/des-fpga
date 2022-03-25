/**
 * Round function del round 11: funzione f(R, K)
 *
 * Utilizza R10 del round precedente e K11
 * per calcolare il valore (facendo lo XOR con L10) di R11.
*/

module f_k11(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K11;
    k11 k11_inst(
        .out(K11[48:1])
    );

    f f_inst_11(
        .R(R[32:1]),
        .K(K11[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
