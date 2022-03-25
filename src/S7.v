/**
 * S7: S Box 7
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S7
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S7
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S7.
 *
 * La matrice S7 e' presente nel file utility/sboxes/s7.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S7(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 4;
            1 : out = 13;
            2 : out = 11;
            3 : out = 0;
            4 : out = 2;
            5 : out = 11;
            6 : out = 14;
            7 : out = 7;
            8 : out = 15;
            9 : out = 4;
            10 : out = 0;
            11 : out = 9;
            12 : out = 8;
            13 : out = 1;
            14 : out = 13;
            15 : out = 10;
            16 : out = 3;
            17 : out = 14;
            18 : out = 12;
            19 : out = 3;
            20 : out = 9;
            21 : out = 5;
            22 : out = 7;
            23 : out = 12;
            24 : out = 5;
            25 : out = 2;
            26 : out = 10;
            27 : out = 15;
            28 : out = 6;
            29 : out = 8;
            30 : out = 1;
            31 : out = 6;
            32 : out = 1;
            33 : out = 6;
            34 : out = 4;
            35 : out = 11;
            36 : out = 11;
            37 : out = 13;
            38 : out = 13;
            39 : out = 8;
            40 : out = 12;
            41 : out = 1;
            42 : out = 3;
            43 : out = 4;
            44 : out = 7;
            45 : out = 10;
            46 : out = 14;
            47 : out = 7;
            48 : out = 10;
            49 : out = 9;
            50 : out = 15;
            51 : out = 5;
            52 : out = 6;
            53 : out = 0;
            54 : out = 8;
            55 : out = 15;
            56 : out = 0;
            57 : out = 14;
            58 : out = 5;
            59 : out = 2;
            60 : out = 9;
            61 : out = 3;
            62 : out = 2;
            63 : out = 12;
        endcase
    end
endmodule
