regtable = {}
regtable["$zr"] = "00000"
regtable["$at"] = "00001"
regtable["$v0"] = "00010"
regtable["$v1"] = "00011"
regtable["$a0"] = "00100"
regtable["$a1"] = "00101"
regtable["$a2"] = "00110"
regtable["$a3"] = "00111"
regtable["$t0"] = "01000"
regtable["$t1"] = "01001"
regtable["$t2"] = "01010"
regtable["$t3"] = "01011"
regtable["$t4"] = "01100"
regtable["$t5"] = "01101"
regtable["$t6"] = "01110"
regtable["$t7"] = "01111"
regtable["$s0"] = "10000"
regtable["$s1"] = "10001"
regtable["$s2"] = "10010"
regtable["$s3"] = "10011"
regtable["$s4"] = "10100"
regtable["$s5"] = "10101"
regtable["$s6"] = "10110"
regtable["$s7"] = "10111"
regtable["$t8"] = "11000"
regtable["$t9"] = "11001"
regtable["$k0"] = "11010"
regtable["$k1"] = "11011"
regtable["$gp"] = "11100"
regtable["$sp"] = "11101"
regtable["$fp"] = "11110"
regtable["$ra"] = "11111"
for i in range(32):
    regtable[f"${i}"] = format(i, '05b')

optable = {}
optable["add"] = "000000"
optable["sub"] = "000000"
optable["and"] = "000000"
optable["or"] = "000000"
optable["slt"] = "000000"
optable["sltu"] = "000000"
optable["addu"] = "000000"
optable["subu"] = "000000"
optable["addi"] = "001000"
optable["andi"] = "001100"
optable["ori"] = "001101"
optable["lw"] = "100011"
optable["sw"] = "101011"
optable["beq"] = "000100"
optable["bne"] = "000101"
optable["j"] = "000010"
optable["jal"] = "000011"
optable["addiu"] = "001001"

functable = {}
functable["add"] = "100000"
functable["sub"] = "100010"
functable["and"] = "100100"
functable["or"] = "100101"
functable["slt"] = "101010"
functable["sltu"] = "101011"
functable["addu"] = "100001"
functable["subu"] = "100011"

print("`timescale 1ns / 1ps\n\
\n\
//------------------------------------------------------------------------------\n\
// Module: InstROM\n\
// Brief : Instruction memory initialized with sample program words.\n\
//------------------------------------------------------------------------------\n\
module InstROM (\n\
  input  [31:0] Addr,  // Addr-Instruction address\n\
  output [31:0] Inst   // Inst-Instruction\n\
);\n\
\n\
  reg [31:0] InstROM[255:0]; // InstROM-Instruction memory\n\
\n\
  assign Inst = InstROM[Addr[9:2]];\n\
  integer i;\n\
  initial begin\n\
    for (i = 0; i < 256; i = i + 1) InstROM[i] = 32'h00000000;\n\
")

try:
    for i in range(100000): # maximum 100000 instructions
        inst = input()
        instruction = inst.split()
        if len(instruction) == 0: continue
        for j in range(len(instruction)):
            if instruction[j].endswith(','):
                instruction[j] = instruction[j][: -1]
        if instruction[0] == "nop":
            result = "0" * 32
        else:
            result = optable[instruction[0]]
            if optable[instruction[0]] == "000000": # R-type
                rd = regtable[instruction[1]]
                rs = regtable[instruction[2]]
                rt = regtable[instruction[3]]
                # we don't care shift command now
                shamt = "00000"
                func = functable[instruction[0]]
                result = result + rs + rt + rd + shamt + func
            elif instruction[0].startswith('j'): # J-type
                # j and jal instructions
                address = int(instruction[1])
                address_bin = format(address, '026b')
                result = result + address_bin
            else: # I-type
                rt = regtable[instruction[1]]
                if instruction[0] in ["lw", "sw"]: # lw and sw format: rt, offset(rs)
                    # Parse offset(rs) format
                    offset_rs = instruction[2].split('(')
                    offset = int(offset_rs[0], 0)
                    rs = regtable[offset_rs[1].replace(')', '')]
                elif instruction[0] in ["beq", "bne"]: # beq and bne format: rs, rt, offset
                    rs = regtable[instruction[1]]
                    rt = regtable[instruction[2]]
                    offset = int(instruction[3], 0)
                else: # addi, andi, ori format: rt, rs, immediate
                    rs = regtable[instruction[2]]
                    offset = int(instruction[3], 0)
                
                # Convert offset to 16-bit binary (two's complement for negative)
                if offset < 0:
                    offset_bin = format((1 << 16) + offset, '016b')
                else:
                    offset_bin = format(offset, '016b')
                
                result = result + rs + rt + offset_bin
        print(f"    InstROM[{i}]{' ' * (3 - len(str(i)))} = 32'b{result};             // {inst}")
except EOFError:
    pass

print("  end\n\
  \n\
endmodule\n\
")