import sys

# Helper Functions
def writeLine(fill, number_command):
    w.write(fill + number_command + "\n")

def writeALUOp(ALU_command_select, reg):
    if reg == "A":
        w.write(ALU_command_select + "4" +"\n")
    elif reg == "B":
        w.write(ALU_command_select + "5" +"\n")

def writeLineWithMem(fill, number_command, mem):
    w.write(fill + number_command + "\n")
    w.write(mem + "\n")

input_file = sys.argv[1]
output_file = sys.argv[2]

default_fill = "F"

line_count = 0;

with open(input_file, 'r') as f:
    with open(output_file, 'w') as w:
        for line in f:
            line_count += 1;
            tokens = line.split()

            command = tokens[0]

            if command == "LOAD":
                if tokens[1] == "A":
                    writeLineWithMem(default_fill, "0", tokens[2])
                elif tokens[1] == "B":
                    writeLineWithMem(default_fill, "1", tokens[2])

            elif command == "WRITE":
                if tokens[1] == "A":
                    writeLineWithMem(default_fill, "2", tokens[2])
                elif tokens[1] == "B":
                    writeLineWithMem(default_fill, "3", tokens[2])

            elif command == "ADD":
                writeALUOp("0", tokens[1])

            elif command == "SUB":
                writeALUOp("1", tokens[1])

            elif command == "MUL":
                writeALUOp("2", tokens[1])

            elif command == "SHIFTL": # Shifts left A
                writeALUOp("3", tokens[1])

            elif command == "SHIFTR":
                writeALUOp("4", tokens[1])

            elif command == "INCRA":
                writeALUOp("5", tokens[1])

            elif command == "INCRB":
                writeALUOp("6", tokens[1])

            elif command == "DECA":
                writeALUOp("7", tokens[1])

            elif command == "DECB":
                writeALUOp("8", tokens[1])

            elif command == "BREQ":
                writeLineWithMem("9", "6", tokens[2])

            elif command == "BGTQ":
                writeLineWithMem("A", "6", tokens[2])

            elif command == "BLTQ":
                writeLineWithMem("B", "6", tokens[2])

            elif command == "GOTO":
                writeLineWithMem(default_fill, "7", tokens[1])

            elif command == "GOTO_IDLE":
                writeLine(default_fill, "8")

            elif command == "FUNCTION_CALL":
                writeLineWithMem(default_fill, "9", tokens[1])

            elif command == "RETURN":
                writeLine(default_fill, "A")

            elif command == "DEREF":
                if tokens[1] == "A":
                    writeLine(default_fill, "B")
                elif tokens[1] == "B":
                    writeLine(default_fill, "C")

            elif command == "#":
                # Comment, so ignore
                print "Ignoring " + line
            else:
                print "Not a valid command on line " + str(line_count) + ": " + line
                w.write("Not a valid command\n")
