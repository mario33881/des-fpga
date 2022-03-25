"""
DES:

* Acquires user input.
* Connects to the Programmable Logic (FPGA) and passes to it user's input
* Waits for the output
* prints the output

0x00: slv_reg0 -> msg
0x04: slv_reg1 -> ready_part1
0x08: slv_reg2 -> ready_part2
0x0C: slv_reg3 -> read_part1
0x10: slv_reg4 -> done
0x14: slv_reg5 -> enc_msg_part1
0x18: slv_reg6 -> enc_msg_part2
"""

__author__ = "Zenaro Stefano"

import os
import sys
import string
import time

boold = False
virtual_fpga = False

if virtual_fpga:
    from virtualfpga import VirtualFPGA as Overlay
else:
    from pynq import Overlay


def is_ascii(t_msg):
    """
    Returns True if all the chars are printable (ASCII).

    :param string t_msg: input string
    :return bool: True if t_msg is made of ASCII chars
    """
    for l in t_msg:
        if l not in string.printable:
            return False
    return True


def string_to_bits_string(t_string):
    """
    Converts a string of chars into a bits string.

    :param string t_string: string of chars
    :return string: string of bits
    """
    return ''.join(format(ord(i),'b').zfill(8) for i in t_string)


def split_nth_char(t_string, t_n):
    """
    Splits a string into parts that contain <t_n> chars each.

    :param string t_string: input string
    :param int t_n: number of chars per substring
    :return list: list of strings, where each string is made of t_n chars (or less)
    """
    return [t_string[i:i+t_n] for i in range(0, len(t_string), t_n)]


def bitstring_to_bytes(s):
    """
    Converts a bits string into the bytes type.

    :param string s: bit string
    :return bytes: bit string converted into bytes
    """
    return int(s, 2).to_bytes((len(s) + 7) // 8, byteorder='big')


def get_encrypted_message(overlay, msg_block_bits):
    """
    Given an overlay (VirtualFPGA() or pynq overlay) and a 64 message block,
    waits and returns encrypted message block.

    :param overlay: VirtualFPGA() instance or pynq overlay
    :param bytes msg_block_bits: message block to encrypt
    :return str: encrypted msg_block_bits
    """
    msg_part1 = msg_block_bits[0:4]
    msg_part2 = msg_block_bits[4:]

    if boold:
        print("msg_part1:", msg_part1)
        print("msg_part2:", msg_part2)

    # manda prima parte del messaggio e attendi che venga memorizzata
    overlay.des_algo_ip_AXI_0.write(0x00, msg_part1)
    overlay.des_algo_ip_AXI_0.write(0x04, 1)

    while overlay.des_algo_ip_AXI_0.read(0x0C) != 1:
        if boold and virtual_fpga:
            time.sleep(1)

    # porta basso il ready_part1
    overlay.des_algo_ip_AXI_0.write(0x04, 0)

    if boold:
        print("inserita e memorizzata prima parte del messaggio")

    # manda seconda parte del messaggio e attendi che done sia uguale a 1
    overlay.des_algo_ip_AXI_0.write(0x00, msg_part2)
    overlay.des_algo_ip_AXI_0.write(0x08, 1)

    while overlay.des_algo_ip_AXI_0.read(0x10) != 1:
        if boold and virtual_fpga:
            time.sleep(1)

    # porta basso il ready_part2
    overlay.des_algo_ip_AXI_0.write(0x08, 0)

    if boold:
        print("inserita e memorizzata seconda parte del messaggio. Risultato pronto")

    # recupera l'output
    result_part1_int = overlay.des_algo_ip_AXI_0.read(0x14)
    result_part1_bin = bin(result_part1_int)[2:]
    result_part2_int = overlay.des_algo_ip_AXI_0.read(0x18)
    result_part2_bin = bin(result_part2_int)[2:]

    # aggiungo padding a entrambe le parti per raggiungere 64 bit
    while len(result_part1_bin) < 32:
        result_part1_bin = "0" + result_part1_bin

    while len(result_part2_bin) < 32:
        result_part2_bin = "0" + result_part2_bin

    result_bin = result_part1_bin + result_part2_bin

    if boold:
        print("messaggio cifrato:", result_bin)

    return result_bin


if __name__ == "__main__":

    if not virtual_fpga:
        if not (os.path.isfile("system.bit") and os.path.isfile("system.tcl")):
            print("Bitstream file and/or Block Diagram file not found: please, place them into the current folder")
            exit(1)

    if len(sys.argv) != 2:
        print("please pass the message to encrypt as an argument!")
        exit(1)

    msg = sys.argv[1]
    if not is_ascii(msg):
        print("Please enter a message containing ascii characters")
        exit(1)

    overlay = Overlay('system.bit')

    # suddividi l'input in blocchi da 64 bit
    msg_blocks = split_nth_char(msg, 8)
    msg_blocks_bits = []
    for msg_block in msg_blocks:
        msg_blocks_bits.append(bitstring_to_bytes(string_to_bits_string(msg_block)))

    if boold:
        print("msg_blocks:", msg_blocks)
        print("msg_blocks_bits:", msg_blocks_bits)

    # aggiungi padding all'ultima parte del messaggio
    while len(msg_blocks_bits[-1]) < 8:
        msg_blocks_bits[-1] = msg_blocks_bits[-1] + b'\x00'

    if boold:
        print("padded msg_blocks_bits:", msg_blocks_bits)

    # cripta ogni blocco di messaggio
    encrypted_message_blocks = []
    for msg_block_bits in msg_blocks_bits:
        result_bin = get_encrypted_message(overlay, msg_block_bits)
        encrypted_message_blocks.append(result_bin)

    if boold:
        print("\n=====================\n")

    print("ENCRYPTED MESSAGE:")
    print("binary output:")
    for enc_msg in encrypted_message_blocks:
        print(enc_msg, end="")
    print("")

    print("hexadecimal output:")
    for enc_msg in encrypted_message_blocks:
        print(hex(int(enc_msg, 2))[2:], " ", end="")
    print("")
