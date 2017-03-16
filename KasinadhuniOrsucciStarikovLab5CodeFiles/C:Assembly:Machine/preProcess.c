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

int readFile(char *filename, FILE* outFile);
int writeOutput(char* input, FILE* outFile);
char* trimInput(char* line);

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
    printf("Reading data from %s .... ", filename);
    while (fgets(word, LINE_SIZE, fp)) {
        // replace newline character with null termination.
        word[strcspn(word, "\n")] = '\0';
        writeOutput(word, outFile);
    }
    printf("Done\n");
    // Close the file
    fclose(fp);
    return 1;
}

// This function takes user input and parses it. It will strip all
// non-digit characters (while printing an appropriate message to stderr)
// and count up all the #'s. It also takes the previous user input which
// it uses when the user enters only #'s.
int writeOutput(char* line, FILE *outFile) {
    fputs(trimInput(line), outFile);
    return 0;
}

// This function takes a char array and removes all spaces and comments
char* trimInput(char* source)
{
    char* save = source;
    char* move = source;
    while(*move != 0) {
        *save = *move++;
        // Check if comment
        if (*save == ';' || (*save == '/' && *(save + 1) == '/'))
            break;
        else if (*save == ':')
            save = source;
        else if (*save != ' ') //Check if space
            save++; // If it's a space then don't increment (causing i to get overwritten)
    }
    *save = '\n';
    *(++save) = '\0'; // Null terminate i
    return source;
}

