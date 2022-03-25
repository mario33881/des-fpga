/**
 * P
 *
 * Il compito di questo modulo e' di prendere il segnale ```in``` in input
 * e di modificare l'ordine dei bit da mandare in output (segnale ```out```)
 *
 * Il segnale ```in``` corrisponde alla combinazione degli output delle S-Box (S1, ..., S8).
 *
 * Il segnale ```out``` sara' l'output della funzione f(R, K)
 *
 * Questo modulo viene usato dalla funzione di cifratura f(R, K).
 *
 * > Assegnamenti generati da ```utility/permutations/gen_permutations.py```
 * > utilizzando il file ```utility/permutations/p.txt```
*/

module P(
    input [1:32] in,
    output [1:32] out
);
	assign out[1] = in[16];
	assign out[2] = in[7];
	assign out[3] = in[20];
	assign out[4] = in[21];
	assign out[5] = in[29];
	assign out[6] = in[12];
	assign out[7] = in[28];
	assign out[8] = in[17];
	assign out[9] = in[1];
	assign out[10] = in[15];
	assign out[11] = in[23];
	assign out[12] = in[26];
	assign out[13] = in[5];
	assign out[14] = in[18];
	assign out[15] = in[31];
	assign out[16] = in[10];
	assign out[17] = in[2];
	assign out[18] = in[8];
	assign out[19] = in[24];
	assign out[20] = in[14];
	assign out[21] = in[32];
	assign out[22] = in[27];
	assign out[23] = in[3];
	assign out[24] = in[9];
	assign out[25] = in[19];
	assign out[26] = in[13];
	assign out[27] = in[30];
	assign out[28] = in[6];
	assign out[29] = in[22];
	assign out[30] = in[11];
	assign out[31] = in[4];
	assign out[32] = in[25];
endmodule
