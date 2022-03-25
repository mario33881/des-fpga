/**
 * S4: S Box 4
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S4
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S4
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S4.
 *
 * La matrice S4 e' presente nel file utility/sboxes/s4.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S4(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 7;
            1 : out = 13;
            2 : out = 13;
            3 : out = 8;
            4 : out = 14;
            5 : out = 11;
            6 : out = 3;
            7 : out = 5;
            8 : out = 0;
            9 : out = 6;
            10 : out = 6;
            11 : out = 15;
            12 : out = 9;
            13 : out = 0;
            14 : out = 10;
            15 : out = 3;
            16 : out = 1;
            17 : out = 4;
            18 : out = 2;
            19 : out = 7;
            20 : out = 8;
            21 : out = 2;
            22 : out = 5;
            23 : out = 12;
            24 : out = 11;
            25 : out = 1;
            26 : out = 12;
            27 : out = 10;
            28 : out = 4;
            29 : out = 14;
            30 : out = 15;
            31 : out = 9;
            32 : out = 10;
            33 : out = 3;
            34 : out = 6;
            35 : out = 15;
            36 : out = 9;
            37 : out = 0;
            38 : out = 0;
            39 : out = 6;
            40 : out = 12;
            41 : out = 10;
            42 : out = 11;
            43 : out = 1;
            44 : out = 7;
            45 : out = 13;
            46 : out = 13;
            47 : out = 8;
            48 : out = 15;
            49 : out = 9;
            50 : out = 1;
            51 : out = 4;
            52 : out = 3;
            53 : out = 5;
            54 : out = 14;
            55 : out = 11;
            56 : out = 5;
            57 : out = 12;
            58 : out = 2;
            59 : out = 7;
            60 : out = 8;
            61 : out = 2;
            62 : out = 4;
            63 : out = 14;
        endcase
    end
endmodule
