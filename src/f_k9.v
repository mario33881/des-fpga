/**
 * Round function del round 9: funzione f(R, K)
 *
 * Utilizza R8 del round precedente e K9
 * per calcolare il valore (facendo lo XOR con L8) di R9.
*/

module f_k9(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K9;
    k9 k9_inst(
        .out(K9[48:1])
    );

    f f_inst_9(
        .R(R[32:1]),
        .K(K9[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
