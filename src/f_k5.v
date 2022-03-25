/**
 * Round function del round 5: funzione f(R, K)
 *
 * Utilizza R4 del round precedente e K5
 * per calcolare il valore (facendo lo XOR con L4) di R5.
*/

module f_k5(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K5;
    k5 k5_inst(
        .out(K5[48:1])
    );

    f f_inst_5(
        .R(R[32:1]),
        .K(K5[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
