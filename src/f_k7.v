/**
 * Round function del round 7: funzione f(R, K)
 *
 * Utilizza R6 del round precedente e K7
 * per calcolare il valore (facendo lo XOR con L6) di R7.
*/

module f_k7(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K7;
    k7 k7_inst(
        .out(K7[48:1])
    );

    f f_inst_7(
        .R(R[32:1]),
        .K(K7[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
