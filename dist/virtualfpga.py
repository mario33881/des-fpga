import threading
import random
import time

from pyDes import *

k = des(b"$eCrtK$1", ECB)


class VirtualFPGA:

    def __init__(self, name):
        self.overlay_name = name
        self.des_algo_ip_AXI_0 = VirtualOverlay()


class VirtualOverlay:

    def __init__(self):
        """
        0x00: slv_reg0 -> msg
        0x04: slv_reg1 -> ready_part1
        0x08: slv_reg2 -> ready_part2
        0x0C: slv_reg3 -> read_part1
        0x10: slv_reg4 -> done
        0x14: slv_reg5 -> enc_msg_part1
        0x18: slv_reg6 -> enc_msg_part2
        """
        # ogni accensione fa avere valori random ai registri
        self.registers = {
            0x00: random.randint(2, 10000),
            0x04: random.randint(2, 10000),
            0x08: random.randint(2, 10000),
            0x0C: random.randint(2, 10000),
            0x10: random.randint(2, 10000),
            0x14: random.randint(2, 10000),
            0x18: random.randint(2, 10000),
        }

        self.msg_part1 = random.randint(2, 10000)
        self.msg_part2 = random.randint(2, 10000)
        self.tmp_msg = random.randint(2, 10000)

        self.enc_part1_thread = None
        self.enc_part2_thread = None

    def write(self, register, value):
        print("setting {:X} = {}".format(register, value))
        self.registers[register] = value

        if register == 0x00:
            print("saving tmp msg:", value)
            self.tmp_msg = int.from_bytes(value, "big")

        elif register == 0x04 and value == 1:
            self.msg_part1 = self.tmp_msg
            print("0x0C (read_part1) is going to be 1, saving to msg_part1:", self.tmp_msg)
            self.enc_part1_thread = threading.Timer(random.randint(1, 10), lambda: self.write(0x0C, 1))
            self.enc_part1_thread.start()

        elif register == 0x08 and value == 1:
            self.msg_part2 = self.tmp_msg
            print("0x10 (done) is going to be 1, saving to msg_part2:", self.tmp_msg)
            self.enc_part2_thread = threading.Timer(random.randint(1, 10), lambda: self.write(0x10, 1))
            self.enc_part2_thread.start()

        elif register == 0x10 and value == 1:
            print("self.msg_part1:", self.msg_part1)
            print("self.msg_part2:", self.msg_part2)
            msg_part1_bin = bin(self.msg_part1)
            msg_part2_bin = bin(self.msg_part2)
            msg_part1_bytes = int(msg_part1_bin, 2).to_bytes(4, byteorder='big')
            msg_part2_bytes = int(msg_part2_bin, 2).to_bytes(4, byteorder='big')
            #msg = msg_part1_bin[2:] + msg_part2_bin[2:]

            msg_bytes = msg_part1_bytes + msg_part2_bytes # int(msg, 2).to_bytes(8, byteorder='big')
            print("msg_bytes:", msg_bytes)
            py_enc_msg = k.encrypt(msg_bytes.decode(encoding="ascii"))
            print("py_enc_msg:", py_enc_msg)
            py_enc_msg_hex = py_enc_msg.hex()
            print("py_enc_msg_hex:", py_enc_msg_hex)
            py_enc_msg_int = int(py_enc_msg_hex, 16)
            print("py_enc_msg_int:", py_enc_msg_int)
            enc_msg_bits = bin(py_enc_msg_int)[2:]
            while len(enc_msg_bits) < 64:
                enc_msg_bits = "0" + enc_msg_bits
            print("enc_msg_bits:", enc_msg_bits)
            self.registers[0x14] = int(enc_msg_bits[0:32], 2)
            self.registers[0x18] = int(enc_msg_bits[32:], 2)

            print("register output part1:", self.registers[0x14])
            print("register output part2:", self.registers[0x18])

    def read(self, register):
        if register == 0x14 or register == 0x18:
            print("attendo i timer")
            #print(self.enc_part1_thread.__dict__)
            self.enc_part1_thread.join()
            self.enc_part2_thread.join()

        value = self.registers[register]
        print("read {}, got {}".format(register, value))
        return value

