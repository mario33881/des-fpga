import string
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue

from pyDes import *

boold = False

min_rand = 40
max_rand = 100
n_rand_tests = 10_000
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
    to the output given by the FSMD verilog module

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
async def test_FSMD(dut):
    """
    Tests the FSMD module. Waits the amount of time needed by the FSM to memorize each part of the input.

    Random 64 bits inputs are generated and given to the FSMD.
    The encrypted message computed from the FSMD should be equal
    to the encrypted message computed from python using pyDES.py

    :param dut: object that represents the DUT (Device Under Test)
    """

    clock = Clock(dut.clk, 10, units="ns")  # Create a 10ns period clock on port clk
    cocotb.fork(clock.start())              # Start the clock

    if boold:
        dut._log.info("reset input values")

    dut.msg.value = 0
    dut.ready_part1.value = 0
    dut.ready_part2.value = 0

    if boold:
        dut._log.info("reset fsm")

    await Timer(random.randint(min_rand, max_rand), units="ns")
    dut.rst.value = 0
    await Timer(random.randint(min_rand, max_rand), units="ns")
    dut.rst.value = 1
    await Timer(random.randint(min_rand, max_rand), units="ns")

    for _ in range(n_rand_tests):
        msg_1 = generate_string(4)
        msg_1_bits = string_to_bits(msg_1)
        msg_1_signal = BinaryValue(msg_1_bits)
        assert msg_1_signal.binstr == msg_1_bits

        if boold:
            dut._log.info("generated random msg part 1: {} ({})".format(msg_1, msg_1_bits))

        msg_2 = generate_string(4)
        msg_2_bits = string_to_bits(msg_2)
        msg_2_signal = BinaryValue(msg_2_bits)
        assert msg_2_signal.binstr == msg_2_bits

        if boold:
            dut._log.info("generated random msg part 2: {} ({})".format(msg_2, msg_2_bits))

        dut.msg.value = msg_1_signal
        await Timer(random.randint(min_rand, max_rand), units="ns")
        dut.ready_part1.value = 1

        while dut.read_part1.value == 0:
            await Timer(random.randint(min_rand, max_rand), units="ns") # await RisingEdge(dut.clk)

        if boold:
            dut._log.info("saved part 1: {}".format(dut.msg_part1))

        dut.ready_part1.value = 0
        await Timer(random.randint(min_rand, max_rand), units="ns")

        if boold:
            dut._log.info("toggled ready_part1 to true and then false")

        dut.msg.value = msg_2_signal
        await Timer(random.randint(min_rand, max_rand), units="ns")
        dut.ready_part2.value = 1

        while dut.done.value == 0:
            await Timer(random.randint(min_rand, max_rand), units="ns") # await RisingEdge(dut.clk)
            if boold:
                dut._log.info("waiting...")

        if boold:
            dut._log.info("saved part 2: {}".format(dut.msg_part2))

        dut.ready_part2.value = 0
        if boold:
            dut._log.info("toggled ready_part2 to true and then false")

        if boold:
            print("done:", dut.done.value)

        await verify_encryption(msg_1 + msg_2, dut.enc_msg.value.binstr)


if __name__ == "__main__":
    print("please run this script using cocotb with the 'make -f Makefile_FSMD' command")
