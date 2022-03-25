/**
 *
 * FSMD: FSM + DATAPATH dell'algoritmo DES
 *
 * La FSM si occupa di:
 * - inizializzare i segnali in output a 0
 * - attendere la prima meta' del messaggio da crittografare sul segnale msg.
 *   Quando ready_part1 = 1 msg viene memorizzato dalla FSM.
 *   La FSM manda in output read_part1 = 1 quando e' avvenuta la memorizzazione.
 *   > Traducendo una frase in binario la prima meta'
 *   > sono i primi 32 bit letti da sinistra verso destra
 * - attendere la seconda meta' del messaggio da crittografare sul segnale msg.
 *   Quando ready_part2 = 1 msg viene memorizzato dalla FSM.
 * - mandare in output su enc_msg l'output del datapath e impostare done = 1.
 *   Il datapath calcolera' il messaggio crittografato "instantaneamente" man mano che arrivano la prima e poi la seconda meta' del messaggio
 *
 * Il datapath implementa l'algoritmo DES (modalita' operativa ECB) con la chiave memorizzata in hardware.
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

    wire [64:1] datapath_enc_msg;       // output del datapath (verra' scritto in temp_enc_msg_reg, quindi enc_msg, quando verra' criptato il messaggio completo)

    reg [32:1] msg_part1, msg_part2;    // memorizza le due meta' del messaggio in input
    reg read_part1, done;

    wire [64:1] temp_msg_parts;         // collega i registri con le due meta' del messaggio nel datapath
    assign temp_msg_parts = {msg_part1, msg_part2};

    DES des_datapath(
        .in(temp_msg_parts),
        .out(datapath_enc_msg[64:1])
    );

    // ====== FSM

    reg[3:0] STATUS, NEXT_STATUS;

    parameter RESET_ST = 0;
    parameter INIT_ST = 1;
    parameter WAIT_PART1_ST = 2;
    parameter WAIT_PART2_ST = 3;
    parameter CALCULATION_ST = 4;
    parameter DONE_ST = 5;

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
                    NEXT_STATUS <= CALCULATION_ST;
                else
                    NEXT_STATUS <= WAIT_PART2_ST;
            end

            CALCULATION_ST: begin
                // passa allo stato finale
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
                end

                WAIT_PART1_ST: begin
                    // imposta prima meta' del messaggio
                    if (ready_part1 == 1) begin
                        // resetta done e temp_enc_msg_reg (cioe' enc_msg) perche'
					    // l'utente vuole crittografare un nuovo messaggio,
                        // > Li resetta se ready_part1 viene modificato finche' si e' nello stato WAIT_PART1_ST:
                        // > non e' necessario aspettare al massimo un ciclo di clock per resettarli in WAIT_PART2_ST
                        done <= 1'b0;
					    temp_enc_msg_reg <= 64'd0;
                    end
                    msg_part1 <= msg;
                end

                WAIT_PART2_ST: begin
                    // * imposta seconda meta' del messaggio.
                    // * Assicurati che si sia resettato done e temp_enc_msg_reg (cioe' enc_msg) perche'
					//   l'utente vuole crittografare un nuovo messaggio.
                    // * indica all'esterno che la prima parte del messaggio e' stata memorizzata
                    done <= 1'b0;
					temp_enc_msg_reg <= 64'd0;
                    msg_part2 <= msg;
                    read_part1 <= 1'b1;
                end

                // CALCULATION_ST: calcoli effettuati dal datapath con il modulo DES

                DONE_ST: begin
                    // alza il bit di fine e imposta l'output
                    // uguale all'output del datapath.
                    // Poi imponi a zero read_part1 per prepararlo per la lettura del prossimo messaggio
                    done <= 1'b1;
                    read_part1 <= 1'b0;
                    temp_enc_msg_reg <= datapath_enc_msg;
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
