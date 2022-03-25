/**
 * Round function del round 3: funzione f(R, K)
 *
 * Utilizza R2 del round precedente e K3
 * per calcolare il valore (facendo lo XOR con L2) di R3.
*/

module f_k3(
    input [32:1] R,
    output [32:1] OUT
);

    wire [48:1] K3;
    k3 k3_inst(
        .out(K3[48:1])
    );

    f f_inst_3(
        .R(R[32:1]),
        .K(K3[48:1]),
        .OUT(OUT[32:1])
    );
endmodule
