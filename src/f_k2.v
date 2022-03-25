/**
 * Round function del round 2: funzione f(R, K)
 *
 * Utilizza R1 del round precedente e K2
 * per calcolare il valore (facendo lo XOR con L1) di R2.
*/

module f_k2(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K2;
    k2 k2_inst(
        .out(K2[48:1])
    );

    f f_inst_2(
        .R(R[32:1]),
        .K(K2[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
