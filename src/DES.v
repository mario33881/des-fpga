/**
 * DES: datapath dell'algoritmo DES
 *
 * L'algoritmo DES:
 * - esegue una permutazione iniziale sull'input
 *	 > viene scambiato l'ordine dei bit
 *
 * - esegue 16 round in cui viene presa la prima meta' dei bit (Rn) e
 *   la seconda meta' (Ln) in output del round precedente per calcolare una
 *	 nuova sequenza di bit {Ln+1 Rn+1} dove:
 *		- Ln+1 = Rn
 *		- Rn+1 = Ln ^ f(Rn, Kn)
 *
 *   NOTA: in questo modulo per eseguire i calcoli della funzione f(Rn, Kn)
 *         si instanzano moduli f_kn(Rn) che internamente hanno Kn gia' definito
 *         perche' la chive e' memorizzata internamente in hardware.
 *
 * - esegue una permutazione finale sull'output {R16 L16} del round 16.
 *	 > viene scambiato l'ordine dei bit.
 *   NOTA: Le meta' R(ight) e L(eft) dell'output del round 16 vengono scambiati.
 *
*/

module DES(
    input [64:1] in,
    output [64:1] out
);

    wire [32:1] l0, r0;
    wire [32:1] l1, r1, f_k1_out;
    wire [32:1] l2, r2, f_k2_out;
    wire [32:1] l3, r3, f_k3_out;
    wire [32:1] l4, r4, f_k4_out;
    wire [32:1] l5, r5, f_k5_out;
    wire [32:1] l6, r6, f_k6_out;
    wire [32:1] l7, r7, f_k7_out;
    wire [32:1] l8, r8, f_k8_out;
    wire [32:1] l9, r9, f_k9_out;
    wire [32:1] l10, r10, f_k10_out;
    wire [32:1] l11, r11, f_k11_out;
    wire [32:1] l12, r12, f_k12_out;
    wire [32:1] l13, r13, f_k13_out;
    wire [32:1] l14, r14, f_k14_out;
    wire [32:1] l15, r15, f_k15_out;
    wire [32:1] l16, r16, f_k16_out;

    // permutazione iniziale
    wire [64:1] in_ip;
    IP ip_inst(in, in_ip);

    assign {l0, r0} = in_ip;

    // round 1
    f_k1 f_k1_inst(
        .R(r0[32:1]),
        .OUT(f_k1_out[32:1])
    );

    assign l1 = r0;
    assign r1 = l0 ^ f_k1_out;

    // round 2
    f_k2 f_k2_inst(
        .R(r1[32:1]),
        .OUT(f_k2_out[32:1])
    );

    assign l2 = r1;
    assign r2 = l1 ^ f_k2_out;

    // round 3
    f_k3 f_k3_inst(
        .R(r2[32:1]),
        .OUT(f_k3_out[32:1])
    );

    assign l3 = r2;
    assign r3 = l2 ^ f_k3_out;

    // round 4
    f_k4 f_k4_inst(
        .R(r3[32:1]),
        .OUT(f_k4_out[32:1])
    );

    assign l4 = r3;
    assign r4 = l3 ^ f_k4_out;

    // round 5
    f_k5 f_k5_inst(
        .R(r4[32:1]),
        .OUT(f_k5_out[32:1])
    );

    assign l5 = r4;
    assign r5 = l4 ^ f_k5_out;

    // round 6
    f_k6 f_k6_inst(
        .R(r5[32:1]),
        .OUT(f_k6_out[32:1])
    );

    assign l6 = r5;
    assign r6 = l5 ^ f_k6_out;

    // round 7
    f_k7 f_k7_inst(
        .R(r6[32:1]),
        .OUT(f_k7_out[32:1])
    );

    assign l7 = r6;
    assign r7 = l6 ^ f_k7_out;

    // round 8
    f_k8 f_k8_inst(
        .R(r7[32:1]),
        .OUT(f_k8_out[32:1])
    );

    assign l8 = r7;
    assign r8 = l7 ^ f_k8_out;

    // round 9
    f_k9 f_k9_inst(
        .R(r8[32:1]),
        .OUT(f_k9_out[32:1])
    );

    assign l9 = r8;
    assign r9 = l8 ^ f_k9_out;

    // round 10
    f_k10 f_k10_inst(
        .R(r9[32:1]),
        .OUT(f_k10_out[32:1])
    );

    assign l10 = r9;
    assign r10 = l9 ^ f_k10_out;

    // round 11
    f_k11 f_k11_inst(
        .R(r10[32:1]),
        .OUT(f_k11_out[32:1])
    );

    assign l11 = r10;
    assign r11 = l10 ^ f_k11_out;

    // round 12
    f_k12 f_k12_inst(
        .R(r11[32:1]),
        .OUT(f_k12_out[32:1])
    );

    assign l12 = r11;
    assign r12 = l11 ^ f_k12_out;

    // round 13
    f_k13 f_k13_inst(
        .R(r12[32:1]),
        .OUT(f_k13_out[32:1])
    );

    assign l13 = r12;
    assign r13 = l12 ^ f_k13_out;

    // round 14
    f_k14 f_k14_inst(
        .R(r13[32:1]),
        .OUT(f_k14_out[32:1])
    );

    assign l14 = r13;
    assign r14 = l13 ^ f_k14_out;

    // round 15
    f_k15 f_k15_inst(
        .R(r14[32:1]),
        .OUT(f_k15_out[32:1])
    );

    assign l15 = r14;
    assign r15 = l14 ^ f_k15_out;

    // round 16
    f_k16 f_k16_inst(
        .R(r15[32:1]),
        .OUT(f_k16_out[32:1])
    );

    assign l16 = r15;
    assign r16 = l15 ^ f_k16_out;

    // permutazione finale
    inverse_IP inverse_IP_inst({r16, l16}, out);

    `ifdef WAVEFORM_DES
    initial begin
        $dumpfile("DES.vcd");
        $dumpvars;
        #1;
    end
    `endif
endmodule
