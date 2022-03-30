/**
 * K_SELECTOR:
 *
 * Multiplexer da 16 ingressi da 48 bit ciascuno usato per selezionare la Kn corretta.
 * > n e' il numero del round corrente. Kn e' il risultato di una computazione sulla chiave di cifratura.
*/

module K_selector (
    input [1:5] selector,
    output [48:1] K
);

    reg [48:1] K;

    wire [48:1] k1_wire;
    k1 k1_inst(.out(k1_wire));

    wire [48:1] k2_wire;
    k2 k2_inst(.out(k2_wire));

    wire [48:1] k3_wire;
    k3 k3_inst(.out(k3_wire));

    wire [48:1] k4_wire;
    k4 k4_inst(.out(k4_wire));

    wire [48:1] k5_wire;
    k5 k5_inst(.out(k5_wire));

    wire [48:1] k6_wire;
    k6 k6_inst(.out(k6_wire));

    wire [48:1] k7_wire;
    k7 k7_inst(.out(k7_wire));

    wire [48:1] k8_wire;
    k8 k8_inst(.out(k8_wire));

    wire [48:1] k9_wire;
    k9 k9_inst(.out(k9_wire));

    wire [48:1] k10_wire;
    k10 k10_inst(.out(k10_wire));

    wire [48:1] k11_wire;
    k11 k11_inst(.out(k11_wire));

    wire [48:1] k12_wire;
    k12 k12_inst(.out(k12_wire));

    wire [48:1] k13_wire;
    k13 k13_inst(.out(k13_wire));

    wire [48:1] k14_wire;
    k14 k14_inst(.out(k14_wire));

    wire [48:1] k15_wire;
    k15 k15_inst(.out(k15_wire));

    wire [48:1] k16_wire;
    k16 k16_inst(.out(k16_wire));

    always @(selector) begin
        case (selector)
            0: K <= k1_wire;
            1: K <= k2_wire;
            2: K <= k3_wire;
            3: K <= k4_wire;
            4: K <= k5_wire;
            5: K <= k6_wire;
            6: K <= k7_wire;
            7: K <= k8_wire;
            8: K <= k9_wire;
            9: K <= k10_wire;
            10: K <= k11_wire;
            11: K <= k12_wire;
            12: K <= k13_wire;
            13: K <= k14_wire;
            14: K <= k15_wire;
            15: K <= k16_wire;
            default: K <= 48'd0;
        endcase
    end
endmodule
