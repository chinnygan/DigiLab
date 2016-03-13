import sys

# Helper Functions
def writeLine(fill, number_command):
    w.write(fill + number_command + "\n")

def writeAddr(addr):
    w.write(addr + "\n")

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
interrupt_timer_address = "timer_interrupt" # Give the label here, make sure it is in input file
interrupt_mouse_address = "mouse_interrupt"

line_count = -1;

labels = {}

with open(input_file, 'r') as f:
    with open(output_file, 'w') as w:
        # Do initial pass to collect label addresses
        for line in f:
            line_count += 1
            line = line.strip()
            tokens = line.split()

            command = tokens[0]

            # Process labels, track line counts
            if command == "LABEL":
                label = tokens[1]
                labels[label] = hex(line_count)[2:]
                line_count -= 1 # MINUS ONE FROM LABELS, THEY DONT APPEAR IN FINAL FILE
            elif command == "LOAD":
                line_count += 1 # NEED TO ADD ONE TO 2 BYTE COMMANDS
            elif command == "WRITE":
                line_count += 1
            elif command == "ADD":
                pass
            elif command == "SUB":
                pass
            elif command == "MUL":
                pass
            elif command == "SHIFTL": # Shifts left A
                pass
            elif command == "SHIFTR":
                pass
            elif command == "INCRA":
                pass
            elif command == "INCRB":
                pass
            elif command == "DECA":
                pass
            elif command == "DECB":
                pass
            elif command == "AND":
                pass
            elif command == "XOR":
                pass
            elif command == "OR":
                pass
            elif command == "BREQ":
                line_count += 1
            elif command == "BGTQ":
                line_count += 1
            elif command == "BLTQ":
                line_count += 1
            elif command == "GOTO":
                line_count += 1
            elif command == "GOTO_IDLE":
                pass
            elif command == "FUNCTION_CALL":
                line_count += 1
            elif command == "RETURN":
                pass
            elif command == "DEREF":
                pass
            elif command == "#":
                line_count -= 1
            else:
                pass

        # Skip back to start
        line_count = -1
        f.seek(0)

        # Do second pass for actual program
        for line in f:
            line_count += 1
            tokens = line.split()

            command = tokens[0]

            if command=="LABEL":
                line_count -= 1
            elif command == "LOAD":
                if tokens[1] == "A":
                    line_count += 1
                    writeLineWithMem(default_fill, "0", tokens[2])
                elif tokens[1] == "B":
                    line_count += 1
                    writeLineWithMem(default_fill, "1", tokens[2])

            elif command == "WRITE":
                if tokens[1] == "A":
                    line_count += 1
                    writeLineWithMem(default_fill, "2", tokens[2])
                elif tokens[1] == "B":
                    line_count += 1
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

            elif command == "AND":
                writeALUOp("C", tokens[1])

            elif command == "XOR":
                writeALUOp("D", tokens[1])

            elif command == "OR":
                writeALUOp("E", tokens[1])

            elif command == "BREQ":
                line_count += 1
                label = tokens[1]
                writeLineWithMem("9", "6", labels[label])

            elif command == "BGTQ":
                line_count += 1
                label = tokens[1]
                writeLineWithMem("A", "6", labels[label])

            elif command == "BLTQ":
                line_count += 1
                label = tokens[1]
                writeLineWithMem("B", "6", labels[label])

            elif command == "GOTO":
                line_count += 1
                label = tokens[1]
                writeLineWithMem(default_fill, "7", labels[label])

            elif command == "GOTO_IDLE":
                writeLine(default_fill, "8")

            elif command == "FUNCTION_CALL":
                line_count += 1
                label = tokens[1]
                writeLineWithMem(default_fill, "9", labels[label])

            elif command == "RETURN":
                writeLine(default_fill, "A")

            elif command == "DEREF":
                if tokens[1] == "A":
                    writeLine(default_fill, "B")
                elif tokens[1] == "B":
                    writeLine(default_fill, "C")

            elif command == "#":
                line_count -= 1
                # Comment, so ignore
                print "Ignoring " + line
            else:
                print "Not a valid command on line " + str(line_count) + ": " + line
                w.write("Not a valid command\n")

        while line_count < 253:
            writeLine(default_fill, default_fill)
            line_count += 1

        # Timer interrupt adrress defaults to 00
        if interrupt_timer_address in labels:
            writeAddr(labels[interrupt_timer_address])
        else:
            writeAddr("00")

        # Mouse interrupt adrress defaults to 00
        if interrupt_mouse_address in labels:
            writeAddr(labels[interrupt_mouse_address])
        else:
            writeAddr("00")


for label, hval in labels.items():
    print '{}\t{}'.format(label,hval)
