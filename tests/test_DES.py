import string
import random

import cocotb
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue

from pyDes import *

boold = False

min_rand = 40
max_rand = 100
n_rand_tests = 1_000
k = des(b"$eCrtK$1", ECB)


def generate_string(t_length):
    """
    Generates a <t_length> long string made of visible
    (no spaces, tabs, ...) and printable chars.

    :param int t_length: length of the returned string
    :return string: random <t_length> long string
    """
    chars_iter = filter(lambda x: ord(x) > 32, string.printable)
    chars = [char for char in chars_iter]
    return ''.join(random.choices(chars, k=t_length))


def string_to_bits(t_string):
    """
    Converts a string of chars into a bits string.

    :param string t_string: string of chars
    :return string: string of bits
    """
    return ''.join(format(ord(i),'b').zfill(8) for i in t_string)


async def verify_encryption(t_msg, verilog_enc_msg_bits):
    """
    Asserts that t_msg encrypted by pyDES.py should be equal
    to the output given by the DES verilog module

    :param string t_msg: message to encrypt
    :param string verilog_enc_msg_bits: string of bits, output of the verilog module
    """
    py_enc_msg = k.encrypt(t_msg)
    py_enc_msg_hex = py_enc_msg.hex()
    py_enc_msg_int = int(py_enc_msg_hex, 16)
    verilog_enc_msg_int = int(verilog_enc_msg_bits, 2)

    if boold:
        print("t_msg:", t_msg)
        print("py_enc_msg:", py_enc_msg_int)
        print("verilog_enc_msg_int:", verilog_enc_msg_int)

    assert py_enc_msg_int == verilog_enc_msg_int


@cocotb.test()
async def test_DES(dut):
    """
    Tests the DES module.

    Random 64 bits inputs are generated and given to the FSMD.
    The encrypted message computed from the FSMD should be equal
    to the encrypted message computed from python using pyDES.py

    :param dut: object that represents the DUT (Device Under Test)
    """

    if boold:
        dut._log.info("reset input values")

    dut._id("in", extended=False).value = 0

    for _ in range(n_rand_tests):
        msg = generate_string(8)
        msg_bits = string_to_bits(msg)
        msg_signal = BinaryValue(msg_bits)
        assert msg_signal.binstr == msg_bits

        if boold:
            dut._log.info("generated random msg: {} ({})".format(msg, msg_bits))

        dut._id("in", extended=False).value = msg_signal
        await Timer(random.randint(min_rand, max_rand), units="ns")

        await verify_encryption(msg, dut.out.value.binstr)


if __name__ == "__main__":
    print("please run this script using cocotb with the 'make -f Makefile_DES' command")
