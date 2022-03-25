"""
Generates kn.v files using the key given as an argument.
"""
import sys
from pyDes import *

if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("please enter only one parameter: the encryption key!")
        exit(1)

    key = sys.argv[1]

    k = des(key, ECB)

    keys_matr = [kn for kn in k.Kn]
    keys = []
    for k in keys_matr:
        keys.append("".join(str(bit) for bit in k))

    for i, key in enumerate(keys):
        assert len(key) == 48
        with open(f"k{i+1}.v", "w") as fout:
            fout.write(f"module k{i+1}(output [48:1] out);\n")
            fout.write("    assign out = 48'b" + key + ";\n")
            fout.write("endmodule\n")
