/*
 * Daniel Starikov
 * EE469 Lab 4-5
 * Simple Assembly Compiler
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>

#define LINE_SIZE 1000
// Binary function macro (0b works on gcc, but not everyone has access to that)
#define B(x) S_to_binary_(#x)

static inline unsigned long long S_to_binary_(const char *s)
{
            unsigned long long i = 0;
                    while (*s) {
                                        i <<= 1;
                                                        i += *s++ - '0';
                                                                }
                            return i;
}

int lineNumber = 0;
int readFile(char *filename, FILE* outFile);
int writeOutput(char* input, FILE* outFile);
int parseInput(char* line);
int convertInput(char* instruction, char* dst, char* src1, char* src2, int number);
int format_R(int opCode, char* dst, char* src1, int shamt, char* src2);
int format_I(int opCode, char* dst, char* src, int ALU_immediate);
int format_D(int opCode, char* dst, char* src1, int DT_address);
int format_B(int opCode, int BR_address);
int format_C(int opCode, int BR_address, char* dst);
int convertReg(char* reg);

int main(int argc, char *argv[]) {
    // This is based off the GNU example of parsing arguments with getOpt found here:
    // https://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html

    // This character array stores the output file
    char *outValue = NULL;
    int index;
    int c;

    opterr = 0;

    while ((c = getopt (argc, argv, "o:")) != -1) {
        switch (c) {
            case 'o':
                outValue = optarg;
                break;
            case '?':
                if (optopt == 'o')
                    fprintf (stderr, "Option -%c requires an argument.\n", optopt);
                else if (isprint (optopt))
                    fprintf (stderr, "Unknown option `-%c'.\n", optopt);
                else
                    fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
                    return 1;
            default:
                abort ();
        }
    }

    if (optind != argc - 1) {
        fprintf(stderr, "Can only read from one input file\n");
        return 1;
    }

    FILE* output;

    if (!outValue) {
        outValue = "a.out";
    }

    output = fopen(outValue, "w");
    if (!output) {
        fprintf(stderr, "Couldn't write to file %s\n", outValue);
    }


    readFile(argv[optind], output);
    return 0;
}

// This function reads legv8 assembly from a file line by line
int readFile(char *filename, FILE *outFile) {
    // Buffer for lines read from file
    char word[LINE_SIZE];
    FILE *fp;
    fp = fopen(filename, "r");
    // Check if the filepointer is null. If it is print an appropriate error
    if (!fp) {
        fprintf(stderr, "The file %s does not exist\n", filename);
        return 0;
    }
    printf("Reading data from %s .... \n", filename);
    while (fgets(word, LINE_SIZE, fp)) {
        // replaceint format_C(int opCode, int BR_address, char* dst) { newline character with null termination.
        word[strcspn(word, "\n")] = '\0';
        lineNumber++;
        writeOutput(word, outFile);
    }
    printf("Done\n");
    // Close the file
    fclose(fp);
    return 1;
}

// This function takes the integer representation of an opcode and prints it
// to the output file in hexadecimal format.
int writeOutput(char* line, FILE *outFile) {
    fprintf(outFile, "%x\n", parseInput(line));
    return 0;
}

// This function takes a comma delimited line and separates the various parts
// of the instruction based off that. All immediate numbers (such as immediate constants
// and memory addresses) need to be prepended with a # to be properly recognized
int parseInput(char* line) {
    char seps[] = ",";
    char linecpy[LINE_SIZE];
    strcpy(linecpy, line);
    // This is based off of code from StackOverflow explaining how to use the
    // strtok to split char arrays using delimiters.
    // http://stackoverflow.com/questions/1483206/how-to-tokenize-string-to-array-of-int-in-c/1483218

    char* token;
    char input[4][20];
    for (int i = 0; i < 4; i ++ ) {
        input[i][0] = '\0';
    }
    int i = 0;
    int number = 0;
    token = strtok (line, seps);

    while (token != NULL) {
        if (token[0] == '#') {
            number = atoi(++token);
        } else {
            strcpy(input[i++], token);
        }
        token = strtok (NULL, seps);
    }

    printf("");
    for (int i = 0; i < 4; i++) {
        printf("input[%d] = %s   ", i, input[i]);
    }
    printf("number = %d\n", number);

    return convertInput(input[0], input[1], input[2], input[3], number);
}

// This function takes the various parts of an instruction and returns the integer opcode.
int convertInput(char* instruction, char* dst, char* src1, char* src2, int number) {
    int opCode = -1;
    char format = '\0';
    // Ugly but gets the job done.
    if (!strcmp(instruction, "B")) {
        format = 'B';
        opCode = B(000101); //0x0A0
    } else if (!strcmp(instruction, "B.GT")) {
        format = 'C';
        opCode = B(01010100); //0x2A0
    } else if (!strcmp(instruction, "BR")) {
        format = 'R';
        opCode = 0x6B0;
    } else if (!strcmp(instruction, "ADD")) {
        format = 'R';
        opCode = 0x458;
    } else if (!strcmp(instruction, "NOP")) {
        format = 'R';
        opCode = 0;
    } else if (!strcmp(instruction, "SUB")) {
        format = 'R';
        opCode = 0x658;
    } else if (!strcmp(instruction, "AND")) {
        format = 'R';
        opCode = 0x450;
    } else if (!strcmp(instruction, "ORR")) {
        format = 'R';
        opCode = 0x550;
    } else if (!strcmp(instruction, "EOR")) {
        format = 'R';
        opCode = 0x650;
    } else if (!strcmp(instruction, "LSL")) {
        format = 'R';
        opCode = 0x69B;
    } else if (!strcmp(instruction, "LDURSW")) {
        format = 'D';
        opCode = 0x5C4;
    } else if (!strcmp(instruction, "STURW")) {
        format = 'D';
        opCode = 0x5C0;
    } else if (!strcmp(instruction, "ADDI")) {
        format = 'I';
        opCode = B(1001000100); //0x488
    } else {
        fprintf(stderr, "Unknown instruction replaced by NOP: %d: %s\n", lineNumber, instruction);
        return 0;
    }

    switch (format) {
        case 'R' :
            return format_R(opCode, dst, src1, number, src2);
        case 'B' :
            return format_B(opCode, number);
        case 'C' :
            return format_C(opCode, number, dst);
        case 'I' :
            return format_I(opCode, dst, src1, number);
        case 'D' :
            return format_D(opCode, dst, src1, number);
        default :
            return 0;
    }
}

// The following format functions take the various fields from the instruction
// and the opCode and use them to return the full instruction as an integer.
int format_R(int opCode, char* dst, char* src1, int shamt, char* src2) {
    opCode = opCode << 21;
    int Rd = convertReg(dst);
    int Rn = convertReg(src1);
    int Rm = convertReg(src2);
    opCode += Rd + (Rn << 5) + (shamt << 10) + (Rm << 16);
    return opCode;
}

int format_B(int opCode, int BR_address) {
    opCode = opCode << 26;
    return opCode + BR_address;
}

int format_C(int opCode, int BR_address, char* dst) {
    opCode = opCode << 24;
    int Rt = 0;
    Rt = convertReg(dst);
    opCode += (BR_address << 5) + Rt;
    return opCode;
}

int format_I(int opCode, char* dst, char* src, int ALU_immediate) {
    opCode = opCode << 22;
    int Rd = 0;
    int Rn = 0;
    Rd = convertReg(dst);
    Rn = convertReg(src);
    opCode += Rd + (Rn << 5) + (ALU_immediate << 10);
    return opCode;
}

int format_D(int opCode, char* dst, char* src, int DT_address) {
    opCode = opCode << 21;
    int Rn = 0;
    int Rt = 0;
    // Check for registers that are being dereferenced
    if (src[0] == '[') {
        // Rn is always the memory access register.
        // This takes care of the fact that LDUR and STUR use different order
        // of registers for memory accesses.
        Rn = convertReg(++src);
        Rt = convertReg(dst);
    } else if (dst[0] == '[') {
        Rn = convertReg(++dst);
        Rt = convertReg(src);
    }
    opCode += (Rn << 5) + Rt + (DT_address << 12);
    return opCode;
}

int convertReg(char* reg) {
    if (!strcmp(reg, "XZR")) // Check if it's the Zero register
        return B(11111);
    else if (toupper(reg[0]) == 'X') // Otherwise remove the X, leaving only the register number
        return atoi(++reg);
    else if (reg[0] != 0) // If none of those worked then this is an invalid register
        // Check to see if the register name is empty. If not then print out an error
        fprintf(stderr, "%s isn't a valid register!\n%d\n", reg, lineNumber);
    return 0;
}
