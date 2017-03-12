# Assignment: Lab 4
# 	  Author: Daniel Starikov
# 		Date: 02/27/2017
#
# This is makefile is for compiling and using the assembler
#
# USAGE INSTRUCTIONS
# to create the compiler executable use: "make compiler"
# to create the preprocessor executable: "make preprocessor"
# to preprocess code: "make preprocess $CODE=filename.s"
# to compile and preprocess code: "make compile $CODE=filename.s"
#
# You can just run the last option and it will take of everything for you
# taking the C source files, your LEGv8 Assembly code and outputting:
# 1. processed.s - your assembly code with line numbers and comments removed
# 2. machine.list - the machine code list of instructions in hexadecimal 


compiler: compile.c 
	gcc compile.c -o $@ 

preprocessor: preProcess.c
	gcc preProcess.c -o $@

preprocess: $(CODE) preprocessor
	./preprocessor $(CODE) -o "processed.s"

compile: $(CODE) preprocess compiler
	./compiler -o machine.list "processed.s"

# clean up build files
clean:
	rm -f compiler preprocessor
