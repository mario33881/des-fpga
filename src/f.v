/**
 * Round function: funzione f(R, K)
 *
 * Utilizza R del round precedente (Rn dove n va da 0 a 15) e K (Kn dove K va da 1 a 16)
 * per calcolare il valore (facendo lo XOR con L) del nuovo R.
*/

module f(
    input [32:1] R,
    input [48:1] K,
    output [32:1] OUT
);
    // estendi R (32 bit) --> R_E (48 bit)
    wire [48:1] R_E;
    E E_inst(R, R_E);

    // XOR tra R_E e la chiave K
    wire [48:1] R_E_XOR_k = R_E ^ K;

    // inserisci l'output dello XOR nelle S Box
    wire [6:1] S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in;
    assign {S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in, S8_in} = R_E_XOR_k;

    wire [4:1] S1_out, S2_out, S3_out, S4_out, S5_out, S6_out, S7_out, S8_out;
    S1 S1_inst(S1_in, S1_out);
    S2 S2_inst(S2_in, S2_out);
    S3 S3_inst(S3_in, S3_out);
    S4 S4_inst(S4_in, S4_out);
    S5 S5_inst(S5_in, S5_out);
    S6 S6_inst(S6_in, S6_out);
    S7 S7_inst(S7_in, S7_out);
    S8 S8_inst(S8_in, S8_out);

    // Permutazione dell'output delle S Box
    wire [32:1] S_out = {S1_out, S2_out, S3_out, S4_out, S5_out, S6_out, S7_out, S8_out};
    P P_inst(S_out, OUT);
endmodule
