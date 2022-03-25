/**
 * Round function del round 4: funzione f(R, K)
 *
 * Utilizza R3 del round precedente e K4
 * per calcolare il valore (facendo lo XOR con L3) di R4.
*/

module f_k4(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K4;
    k4 k4_inst(
        .out(K4[48:1])
    );

    f f_inst_4(
        .R(R[32:1]),
        .K(K4[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
