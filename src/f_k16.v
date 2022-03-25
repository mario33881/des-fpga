/**
 * Round function del round 16: funzione f(R, K)
 *
 * Utilizza R15 del round precedente e K16
 * per calcolare il valore (facendo lo XOR con L15) di R16.
*/

module f_k16(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K16;
    k16 k16_inst(
        .out(K16[48:1])
    );

    f f_inst_16(
        .R(R[32:1]),
        .K(K16[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
