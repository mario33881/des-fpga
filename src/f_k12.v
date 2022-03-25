/**
 * Round function del round 12: funzione f(R, K)
 *
 * Utilizza R11 del round precedente e K12
 * per calcolare il valore (facendo lo XOR con L11) di R12.
*/

module f_k12(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K12;
    k12 k12_inst(
        .out(K12[48:1])
    );

    f f_inst_12(
        .R(R[32:1]),
        .K(K12[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
