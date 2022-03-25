/**
 * Round function del round 1: funzione f(R, K)
 *
 * Utilizza R0 del round precedente e K1
 * per calcolare il valore (facendo lo XOR con L0) di R1.
*/

module f_k1 (
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K1;
    k1 k1_inst(
        .out(K1[48:1])
    );

    f f_inst_1(
        .R(R[32:1]),
        .K(K1[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
