/**
 * S1: S Box 1
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S1
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S1
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S1.
 *
 * La matrice S1 e' presente nel file utility/sboxes/s1.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S1(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 14;
            1 : out = 0;
            2 : out = 4;
            3 : out = 15;
            4 : out = 13;
            5 : out = 7;
            6 : out = 1;
            7 : out = 4;
            8 : out = 2;
            9 : out = 14;
            10 : out = 15;
            11 : out = 2;
            12 : out = 11;
            13 : out = 13;
            14 : out = 8;
            15 : out = 1;
            16 : out = 3;
            17 : out = 10;
            18 : out = 10;
            19 : out = 6;
            20 : out = 6;
            21 : out = 12;
            22 : out = 12;
            23 : out = 11;
            24 : out = 5;
            25 : out = 9;
            26 : out = 9;
            27 : out = 5;
            28 : out = 0;
            29 : out = 3;
            30 : out = 7;
            31 : out = 8;
            32 : out = 4;
            33 : out = 15;
            34 : out = 1;
            35 : out = 12;
            36 : out = 14;
            37 : out = 8;
            38 : out = 8;
            39 : out = 2;
            40 : out = 13;
            41 : out = 4;
            42 : out = 6;
            43 : out = 9;
            44 : out = 2;
            45 : out = 1;
            46 : out = 11;
            47 : out = 7;
            48 : out = 15;
            49 : out = 5;
            50 : out = 12;
            51 : out = 11;
            52 : out = 9;
            53 : out = 3;
            54 : out = 7;
            55 : out = 14;
            56 : out = 3;
            57 : out = 10;
            58 : out = 10;
            59 : out = 0;
            60 : out = 5;
            61 : out = 6;
            62 : out = 0;
            63 : out = 13;
        endcase
    end
endmodule
