import des as des_to_test
import virtualfpga
from pyDes import *

k = des(b"$eCrtK$1", ECB)


def test_get_encrypted_message(data):
    """
    Tests if the encrypted data created by the virtual FPGA
    is equal to <data> once it gets decrypted using pyDES.

    :param bytes data: test input
    """
    overlay = virtualfpga.VirtualFPGA("system.bit")

    enc_msg_bits = des_to_test.get_encrypted_message(overlay, data)
    enc_msg_int = int(enc_msg_bits, 2)

    py_enc_msg = k.encrypt(data)
    py_enc_msg_hex = py_enc_msg.hex()
    py_enc_msg_int = int(py_enc_msg_hex, 16)

    # encrypting using the virtual FPGA should be the same to encrypting using the pyDES module
    assert enc_msg_int == py_enc_msg_int

    # decrypting the virtual FPGA output using pyDES should return the test input
    enc_msg_bytes = int(enc_msg_int).to_bytes(8, "big")
    assert k.decrypt(enc_msg_bytes) == data


if __name__ == "__main__":
    for test_input in [b"test1234", b"testciao"]:
        test_get_encrypted_message(test_input)
