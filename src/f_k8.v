/**
 * Round function del round 8: funzione f(R, K)
 *
 * Utilizza R7 del round precedente e K8
 * per calcolare il valore (facendo lo XOR con L7) di R8.
*/

module f_k8(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K8;
    k8 k8_inst(
        .out(K8[48:1])
    );

    f f_inst_8(
        .R(R[32:1]),
        .K(K8[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
