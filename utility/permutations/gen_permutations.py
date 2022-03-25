import os

curr_dir = os.path.abspath(os.path.dirname(__file__))


def gen_connection(t_input, t_output, t_indentation="\t"):
    """
    Generates the correct assignment instruction.
    """
    int(t_input)

    assignment = t_indentation + "assign out[{}] = in[{}];".format(t_output, t_input)
    return assignment


def gen_permutation(t_input, t_output):
    """
    Generates a permutation module based on the input file.
    """
    with open(t_input, "r") as f_in, open(t_output, "w") as f_out:
        input_line = f_in.readline()
        line_num = 1
        while input_line != "":
            output_line = gen_connection(input_line.strip(), str(line_num))
            f_out.write(output_line + "\n")

            input_line = f_in.readline()
            line_num += 1

    print(t_input + " --> " + t_output)


if __name__ == "__main__":

    for element in os.listdir():
        fullpath_element = os.path.join(curr_dir, element)
        element_name, _extension = os.path.splitext(fullpath_element)

        if os.path.isfile(fullpath_element) and element.endswith(".txt"):
            output_path = os.path.join(curr_dir, element_name + ".v")
            gen_permutation(fullpath_element, output_path)
