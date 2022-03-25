/**
 * S6: S Box 6
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S6
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S6
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S6.
 *
 * La matrice S6 e' presente nel file utility/sboxes/s6.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S6(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 12;
            1 : out = 10;
            2 : out = 1;
            3 : out = 15;
            4 : out = 10;
            5 : out = 4;
            6 : out = 15;
            7 : out = 2;
            8 : out = 9;
            9 : out = 7;
            10 : out = 2;
            11 : out = 12;
            12 : out = 6;
            13 : out = 9;
            14 : out = 8;
            15 : out = 5;
            16 : out = 0;
            17 : out = 6;
            18 : out = 13;
            19 : out = 1;
            20 : out = 3;
            21 : out = 13;
            22 : out = 4;
            23 : out = 14;
            24 : out = 14;
            25 : out = 0;
            26 : out = 7;
            27 : out = 11;
            28 : out = 5;
            29 : out = 3;
            30 : out = 11;
            31 : out = 8;
            32 : out = 9;
            33 : out = 4;
            34 : out = 14;
            35 : out = 3;
            36 : out = 15;
            37 : out = 2;
            38 : out = 5;
            39 : out = 12;
            40 : out = 2;
            41 : out = 9;
            42 : out = 8;
            43 : out = 5;
            44 : out = 12;
            45 : out = 15;
            46 : out = 3;
            47 : out = 10;
            48 : out = 7;
            49 : out = 11;
            50 : out = 0;
            51 : out = 14;
            52 : out = 4;
            53 : out = 1;
            54 : out = 10;
            55 : out = 7;
            56 : out = 1;
            57 : out = 6;
            58 : out = 13;
            59 : out = 0;
            60 : out = 11;
            61 : out = 8;
            62 : out = 6;
            63 : out = 13;
        endcase
    end
endmodule
