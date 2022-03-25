/**
 * S5: S Box 5
 *
 * Le S Box ricevono un input da 0 a 63, 6 bit:
 *
 * Formato: abcdef
 *
 * Dove
 * - "af" e' un valore da 0 a 3 e corrisponde ad una riga della matrice S5
 * - "bcde" e' un valore da a 15 e corrisponde ad una colonna della matrice S5
 *
 * Utilizzando uno script python e' possibile selezionare dalla matrice il valore corrispondente all'output dalla matrice S5.
 *
 * La matrice S5 e' presente nel file utility/sboxes/s5.txt
 * > Assegnamenti nel case generati automaticamente dallo script python utility/sboxes/gen_sboxes.py
*/

module S5(
    input [6:1] in,
    output reg [4:1] out
);

    always @ (in[6:1]) begin
        case (in)
            0 : out = 2;
            1 : out = 14;
            2 : out = 12;
            3 : out = 11;
            4 : out = 4;
            5 : out = 2;
            6 : out = 1;
            7 : out = 12;
            8 : out = 7;
            9 : out = 4;
            10 : out = 10;
            11 : out = 7;
            12 : out = 11;
            13 : out = 13;
            14 : out = 6;
            15 : out = 1;
            16 : out = 8;
            17 : out = 5;
            18 : out = 5;
            19 : out = 0;
            20 : out = 3;
            21 : out = 15;
            22 : out = 15;
            23 : out = 10;
            24 : out = 13;
            25 : out = 3;
            26 : out = 0;
            27 : out = 9;
            28 : out = 14;
            29 : out = 8;
            30 : out = 9;
            31 : out = 6;
            32 : out = 4;
            33 : out = 11;
            34 : out = 2;
            35 : out = 8;
            36 : out = 1;
            37 : out = 12;
            38 : out = 11;
            39 : out = 7;
            40 : out = 10;
            41 : out = 1;
            42 : out = 13;
            43 : out = 14;
            44 : out = 7;
            45 : out = 2;
            46 : out = 8;
            47 : out = 13;
            48 : out = 15;
            49 : out = 6;
            50 : out = 9;
            51 : out = 15;
            52 : out = 12;
            53 : out = 0;
            54 : out = 5;
            55 : out = 9;
            56 : out = 6;
            57 : out = 10;
            58 : out = 3;
            59 : out = 4;
            60 : out = 0;
            61 : out = 5;
            62 : out = 14;
            63 : out = 3;
        endcase
    end
endmodule
