/**
 * S8: S Box 8
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S8
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S8
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S8.
 *
 * La matrice S8 e' presente nel file utility/sboxes/s8.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S8(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 13;
            1 : out = 1;
            2 : out = 2;
            3 : out = 15;
            4 : out = 8;
            5 : out = 13;
            6 : out = 4;
            7 : out = 8;
            8 : out = 6;
            9 : out = 10;
            10 : out = 15;
            11 : out = 3;
            12 : out = 11;
            13 : out = 7;
            14 : out = 1;
            15 : out = 4;
            16 : out = 10;
            17 : out = 12;
            18 : out = 9;
            19 : out = 5;
            20 : out = 3;
            21 : out = 6;
            22 : out = 14;
            23 : out = 11;
            24 : out = 5;
            25 : out = 0;
            26 : out = 0;
            27 : out = 14;
            28 : out = 12;
            29 : out = 9;
            30 : out = 7;
            31 : out = 2;
            32 : out = 7;
            33 : out = 2;
            34 : out = 11;
            35 : out = 1;
            36 : out = 4;
            37 : out = 14;
            38 : out = 1;
            39 : out = 7;
            40 : out = 9;
            41 : out = 4;
            42 : out = 12;
            43 : out = 10;
            44 : out = 14;
            45 : out = 8;
            46 : out = 2;
            47 : out = 13;
            48 : out = 0;
            49 : out = 15;
            50 : out = 6;
            51 : out = 12;
            52 : out = 10;
            53 : out = 9;
            54 : out = 13;
            55 : out = 0;
            56 : out = 15;
            57 : out = 3;
            58 : out = 3;
            59 : out = 5;
            60 : out = 5;
            61 : out = 6;
            62 : out = 8;
            63 : out = 11;
        endcase
    end
endmodule
