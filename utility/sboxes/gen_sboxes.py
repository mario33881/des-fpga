import os

curr_dir = os.path.abspath(os.path.dirname(__file__))


def gen_sbox(t_input, t_output):
    """
    Generates an S Box based on the input file.
    """
    sbox_matrix = []
    with open(t_input, "r") as f_in:
        input_line = f_in.readline()
        line_num = 1
        while input_line != "":
            sbox_matrix.append(input_line.strip().split(" "))

            input_line = f_in.readline()
            line_num += 1

    print(t_input + " --> " + t_output)
    import pprint
    pprint.pprint(sbox_matrix)
    print("")
    with open(t_output, "w") as f_out:
        for in_signal in range(64):
            in_bits = "{:06b}".format(in_signal)
            row_bits = in_bits[0] + in_bits[5]
            row = int(row_bits, 2)
            column_bits = in_bits[1:5]
            column = int(column_bits, 2)
            print(in_signal, "({}, {})".format(row_bits, column_bits), " --> ", sbox_matrix[row][column])
            f_out.write("{}: out = {};\n".format(in_signal, sbox_matrix[row][column]))


    print("-"*20)


if __name__ == "__main__":

    for element in os.listdir():
        fullpath_element = os.path.join(curr_dir, element)
        element_name, _extension = os.path.splitext(fullpath_element)

        if os.path.isfile(fullpath_element) and element.endswith(".txt"):
            output_path = os.path.join(curr_dir, element_name + ".v")
            gen_sbox(fullpath_element, output_path)
