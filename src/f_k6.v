/**
 * Round function del round 6: funzione f(R, K)
 *
 * Utilizza R5 del round precedente e K6
 * per calcolare il valore (facendo lo XOR con L5) di R6.
*/

module f_k6(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K6;
    k6 k6_inst(
        .out(K6[48:1])
    );

    f f_inst_6(
        .R(R[32:1]),
        .K(K6[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
