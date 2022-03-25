/**
 * IP: Initial Permutation
 *
 * Il compito di questo modulo e' di prendere il segnale ```in``` in input
 * e di modificare l'ordine dei bit da mandare in output (segnale ```out```)
 *
 * Il segnale ```in``` corrisponde ai dati presi in input all'algoritmo DES da crittografare.
 *
 * Il segnale ```out``` sara' l'input del primo round.
 *
 * > Assegnamenti generati da ```utility/permutations/gen_permutations.py```
 * > utilizzando il file ```utility/permutations/ip.txt```
*/

module IP (
    input [1:64] in,
    output [1:64] out
);

    assign out[1] = in[58];
	assign out[2] = in[50];
	assign out[3] = in[42];
	assign out[4] = in[34];
	assign out[5] = in[26];
	assign out[6] = in[18];
	assign out[7] = in[10];
	assign out[8] = in[2];
	assign out[9] = in[60];
	assign out[10] = in[52];
	assign out[11] = in[44];
	assign out[12] = in[36];
	assign out[13] = in[28];
	assign out[14] = in[20];
	assign out[15] = in[12];
	assign out[16] = in[4];
	assign out[17] = in[62];
	assign out[18] = in[54];
	assign out[19] = in[46];
	assign out[20] = in[38];
	assign out[21] = in[30];
	assign out[22] = in[22];
	assign out[23] = in[14];
	assign out[24] = in[6];
	assign out[25] = in[64];
	assign out[26] = in[56];
	assign out[27] = in[48];
	assign out[28] = in[40];
	assign out[29] = in[32];
	assign out[30] = in[24];
	assign out[31] = in[16];
	assign out[32] = in[8];
	assign out[33] = in[57];
	assign out[34] = in[49];
	assign out[35] = in[41];
	assign out[36] = in[33];
	assign out[37] = in[25];
	assign out[38] = in[17];
	assign out[39] = in[9];
	assign out[40] = in[1];
	assign out[41] = in[59];
	assign out[42] = in[51];
	assign out[43] = in[43];
	assign out[44] = in[35];
	assign out[45] = in[27];
	assign out[46] = in[19];
	assign out[47] = in[11];
	assign out[48] = in[3];
	assign out[49] = in[61];
	assign out[50] = in[53];
	assign out[51] = in[45];
	assign out[52] = in[37];
	assign out[53] = in[29];
	assign out[54] = in[21];
	assign out[55] = in[13];
	assign out[56] = in[5];
	assign out[57] = in[63];
	assign out[58] = in[55];
	assign out[59] = in[47];
	assign out[60] = in[39];
	assign out[61] = in[31];
	assign out[62] = in[23];
	assign out[63] = in[15];
	assign out[64] = in[7];
endmodule