/**
 *
 * FSMD: FSM + DATAPATH dell'algoritmo DES (modalita' operativa ECB, chiave memorizzata in hardware)
 *
 * La FSM si occupa di:
 * - inizializzare i segnali in output a 0
 * - attendere la prima meta' del messaggio da crittografare sul segnale msg.
 *   Quando ready_part1 = 1, msg viene memorizzato dalla FSM.
 *   La FSM manda in output read_part1 = 1 quando e' avvenuta la memorizzazione.
 *   > Traducendo una frase in binario la prima meta'
 *   > sono i primi 32 bit letti da sinistra verso destra
 * - attendere la seconda meta' del messaggio da crittografare sul segnale msg.
 * - calcolare la permutazione iniziale sull'intero messaggio in input (ottenuto concatenando le due parti)
 *   > Il calcolo viene effettuato dal modulo "IP"
 * - preparare l'output della permutazione per il primo round suddividendolo in due meta' (L_n-1 e R_n-1)
 * - eseguire i 16 round di crittografia:
 *     - seleziona la Kn del round n (round attuale)
 *       > Viene utilizzato il modulo "K_selector"
 *     - Calcola Ln ed Rn:
 *       Ln = R_n-1
 *       Rn = L_n-1 ^ f(R_n-1, Kn)
 *       > f(R_n-1, Kn) viene calcolato dal modulo "f"
 *     - Passa al round successivo incrementando n e memorizzando L in L_n-1 e R in R_n-1
 * - eseguire la permutazione finale sull'output del round 16. (Dove l'output e' R16 + L16, invece di Lx + Rx come per i round precedenti)
 * - mandare in output su enc_msg l'output della permutazione finale e impostare done = 1.
 *
*/

`timescale 1ns / 1ns

module FSMD (
    input [32:1] msg,
    input ready_part1,
    input ready_part2,
    input clk,
    input rst,

    output [64:1] enc_msg,
    output read_part1,
    output done
);

    // ====== REGISTRI E COLLEGAMENTI PER GESTIRE INPUT E OUTPUT DI FSM E DATAPATH

    reg [64:1] temp_enc_msg_reg;        // registro che controlla l'output enc_msg (memorizza 0 finche' non viene eseguito il calcolo del messaggio completo)
    assign enc_msg = temp_enc_msg_reg;

    reg [32:1] msg_part1, msg_part2;    // memorizza le due meta' del messaggio in input
    reg read_part1, done;               // memorizza/controlla i due output. Indicano fine memorizzazione prima parte del messaggio e completamento algoritmo DES

    reg [32:1] prev_L, prev_R, L, R;  // L e R precedenti e attuali
    reg [5:1] round_num;              // contatore del round attuale (conta da 0 a 15, quando arriva a 16 sono finiti i round)

    // modulo per permutazione iniziale
    reg [64:1] init_perm_reg;        // contiene risultato permutazione iniziale quando e' necessario effettuare i round
    wire [64:1] temp_init_perm_out;  // assume il valore di permutazione iniziale degli input

    IP ip_inst(
        .in({msg_part1, msg_part2}),
        .out(temp_init_perm_out)
    );

    // multiplexer per selezionare Kn (n e' il numero del round, round_num+1)
    reg [48:1] round_K_reg;  // usato per memorizzare round_K per la funzione f(R_n-1, Kn)
    wire [48:1] round_K;     // assume il valore K del round attuale

    K_selector K_sel_inst(
        .selector(round_num),
        .K(round_K)
    );

    // modulo funzione f(R_n-1, Kn)
    wire [32:1] f_out_wire; // output funzione f(R_n-1, Kn)

    f f_inst(
        .R(prev_R),
        .K(round_K_reg),
        .OUT(f_out_wire)
    );

    // modulo per permutazione finale
    reg [64:1] final_perm_reg;        // conterra' output della permutazione finale alla fine dei 16 round
    wire [64:1] temp_final_perm_out;  // assume il valore della permutazione finale di R e L in ogni istante

    inverse_IP inv_ip_inst(
        .in({R, L}),
        .out(temp_final_perm_out)
    );

    // ====== FSM

    reg[4:0] STATUS, NEXT_STATUS;

    parameter RESET_ST = 0;
    parameter INIT_ST = 1;
    parameter WAIT_PART1_ST = 2;
    parameter WAIT_PART2_ST = 3;
    parameter INITIAL_PERM_ST = 4;
    parameter INIT_ROUNDS_ST = 5;
    parameter SELECT_K_ST = 6;
    parameter ROUND_CALCULATION_ST = 7;
    parameter PREP_NEXT_ROUND_ST = 8;
    parameter FINAL_PERM_ST = 9;
    parameter DONE_ST = 10;

    always @(STATUS, msg, ready_part1, ready_part2) begin

        case (STATUS)

            RESET_ST: begin
                // passa allo stato di inizializzazione
                NEXT_STATUS <= INIT_ST;
            end

            INIT_ST: begin
                // passa allo stato di attesa della prima parte del messaggio
                NEXT_STATUS <= WAIT_PART1_ST;
            end

            WAIT_PART1_ST: begin
                // passa allo stato di attesa della seconda parte del messaggio
                // dopo aver ricevuto la prima parte
                if (ready_part1 == 1'b1)
                    NEXT_STATUS <= WAIT_PART2_ST;
                else
                    NEXT_STATUS <= WAIT_PART1_ST;
            end

            WAIT_PART2_ST: begin
                // passa allo stato di calcolo del messaggio cifrato
                // dopo aver ricevuto la seconda parte
                if (ready_part2 == 1'b1)
                    NEXT_STATUS <= INITIAL_PERM_ST;
                else
                    NEXT_STATUS <= WAIT_PART2_ST;
            end

            INITIAL_PERM_ST: begin
                // passa allo stato di inizializzazione delle
                // informazioni necessarie per eseguire i round
                NEXT_STATUS <= INIT_ROUNDS_ST;
            end

            INIT_ROUNDS_ST: begin
                // passa allo stato di selezione di K per il round attuale
                NEXT_STATUS <= SELECT_K_ST;
            end

            SELECT_K_ST: begin
                // se non si e' finito di calcolare i 16 round passa allo stato dei calcoli del round
                // altrimenti passa allo stato in cui si effettua la permutazione finale
                if (round_num < 16)
                    NEXT_STATUS <= ROUND_CALCULATION_ST;
                else
                    NEXT_STATUS <= FINAL_PERM_ST;
            end

            ROUND_CALCULATION_ST: begin
                // passa allo stato in cui vengono salvati in prev_L e prev_R L ed R
                // per passare al round successivo.
                // Per indicare il cambio di round verra' incrementato il contatore di round.
                NEXT_STATUS <= PREP_NEXT_ROUND_ST;
            end

            PREP_NEXT_ROUND_ST: begin
                // torna allo stato di selezione della nuova K per il prossimo round
                NEXT_STATUS <= SELECT_K_ST;
            end

            FINAL_PERM_ST: begin
                // fatta la permutazione finale si passa allo stato finale
                NEXT_STATUS <= DONE_ST;
            end

            DONE_ST: begin
                // torna allo stato di attesa della prima meta' del messaggio
				// per ricevere un messaggio nuovo
                NEXT_STATUS <= WAIT_PART1_ST;
            end

            default: begin
                NEXT_STATUS <= STATUS;
            end
        endcase
    end

    // ====== DATAPATH

    always @(posedge clk, negedge rst) begin

        if (rst == 1'b0) begin
            STATUS <= RESET_ST;
        end
        else begin
            STATUS <= NEXT_STATUS;
            case (NEXT_STATUS)

                // RESET_ST: nessun calcolo

                INIT_ST: begin
                    // inizializza registri e output
                    done <= 1'b0;
                    msg_part1 <= 32'd0;
                    msg_part2 <= 32'd0;
                    read_part1 <= 1'b0;
                    temp_enc_msg_reg <= 64'd0;

                    init_perm_reg <= 64'd0;
                    final_perm_reg <= 64'd0;
                    prev_L <= 32'd0;
                    prev_R <= 32'd0;
                    L <= 32'd0;
                    R <= 32'd0;
                    round_num <= 5'd0;
                    round_K_reg <= 48'd0;

                    `ifdef DEBUG
                        $display("inizializzo i registri");
                    `endif
                end

                WAIT_PART1_ST: begin
                    // imposta prima meta' del messaggio
                    if (ready_part1 == 1) begin
                        // resetta tutti i registri perche'
					    // l'utente vuole crittografare un nuovo messaggio,
                        // > Li resetta se ready_part1 viene modificato finche' si e' nello stato WAIT_PART1_ST:
                        // > non e' necessario aspettare al massimo un ciclo di clock per resettarli in WAIT_PART2_ST
                        done <= 1'b0;
					    temp_enc_msg_reg <= 64'd0;

                        init_perm_reg <= 64'd0;
                        final_perm_reg <= 64'd0;
                        prev_L <= 32'd0;
                        prev_R <= 32'd0;
                        L <= 32'd0;
                        R <= 32'd0;
                        round_num <= 5'd0;
                        round_K_reg <= 48'd0;
                    end
                    msg_part1 <= msg;
                    `ifdef DEBUG
                        $display("attendo prima parte del messaggio");
                    `endif
                end

                WAIT_PART2_ST: begin
                    // * imposta seconda meta' del messaggio.
                    // * Assicurati che si siano resettati tutti gli altri registri perche'
					//   l'utente vuole crittografare un nuovo messaggio.
                    // * indica all'esterno che la prima parte del messaggio e' stata memorizzata
                    done <= 1'b0;
					temp_enc_msg_reg <= 64'd0;
                    msg_part2 <= msg;
                    read_part1 <= 1'b1;

                    init_perm_reg <= 64'd0;
                    final_perm_reg <= 64'd0;
                    prev_L <= 32'd0;
                    prev_R <= 32'd0;
                    L <= 32'd0;
                    R <= 32'd0;
                    round_num <= 5'd0;
                    round_K_reg <= 48'd0;
                    `ifdef DEBUG
                        $display("attendo seconda parte del messaggio");
                    `endif
                end

                INITIAL_PERM_ST: begin
                    // memorizza il risultato della permutazione iniziale del messaggio da cifrare
                    init_perm_reg <= temp_init_perm_out;
                    `ifdef DEBUG
                        $display("memorizzo la permutazione dell'input");
                    `endif
                end

                INIT_ROUNDS_ST: begin
                    // memorizza in prev_L e prev_R L0 e R0,
                    // ovvero le due meta' del risultato della permutazione iniziale
                    prev_L <= init_perm_reg[64:33];
                    prev_R <= init_perm_reg[32:1];

                    `ifdef DEBUG
                        $display("memorizzo L0: %h", prev_L);
                        $display("memorizzo R0: %h", prev_R);
                        $display("-----------------------");
                    `endif
                end

                SELECT_K_ST: begin
                    // memorizzo K del round attuale per poter effettuare i calcoli
                    round_K_reg <= round_K;
                end

                ROUND_CALCULATION_ST: begin
                    // effettua i calcoli del round
                    // Ln = R_n-1
                    // Rn = L_n-1 XOR f(R_n-1, Kn)
                    // > dove:
                    // > - Ln e' L e Rn e' R
                    // > - L_n-1 e' prev_L e R_n-1 e' prev_R
                    // > - Kn e' round_K_reg (usato per calcolare f_out_wire)
                    // > - f(R_n-1, Kn) e' f_out_wire

                    `ifdef DEBUG
                        $display("K%d: %h", round_num, round_K_reg);
                        $display("prev_L%d: %h", round_num, prev_L);
                        $display("prev_R%d: %h", round_num, prev_R);
                    `endif

                    L <= prev_R;
                    R <= prev_L ^ f_out_wire;

                    `ifdef DEBUG
                        $display("f_out_wire: %h", f_out_wire);
                        $display("L%d: %h", round_num, L);
                        $display("R%d: %h", round_num, R);
                        $display("-----------------------");
                    `endif
                end

                PREP_NEXT_ROUND_ST: begin
                    // Passa al nuovo round memorizzando i valori di R ed L
                    // nel registro contenente i valori di R ed L del round precedente
                    prev_R <= R;
                    prev_L <= L;
                    round_num <= round_num + 1;
                end

                FINAL_PERM_ST: begin
                    // Memorizza la permutazione finale dell'output del 16 round
                    final_perm_reg <= temp_final_perm_out;
                    `ifdef DEBUG
                        $display("Memorizzo risultato permutazione finale");
                    `endif
                end

                DONE_ST: begin
                    // alza il bit di fine e imposta l'output
                    // uguale all'output della permutazione finale.
                    // Poi imponi a zero read_part1 per prepararlo per la lettura del prossimo messaggio
                    done <= 1'b1;
                    read_part1 <= 1'b0;
                    temp_enc_msg_reg <= final_perm_reg;

                    `ifdef DEBUG
                        $display("Fine");
                    `endif
                end
            endcase
        end
    end

    `ifdef WAVEFORM_FSMD
    initial begin
        $dumpfile("FSMD.vcd");
        $dumpvars;
        #1;
    end
    `endif
endmodule
