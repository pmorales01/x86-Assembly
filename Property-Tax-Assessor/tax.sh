#!/bin/bash

#Author: Pedro Morales
#Program name: Property Tax Assessor
#Purpose: This is a Bash script file whose purpose is to compile and run the program "Property Tax Assessor".

#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble get_assessed_values.asm"
nasm -f elf64 -l get_assessed_values.lis -o get_assessed_values.o get_assessed_values.asm

echo "Assemble sum_values.asm"
nasm -f elf64 -l sum_values.lis -o sum_values.o sum_values.asm

echo "Compile show_property_values.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o show_property_values.o show_property_values.c -std=c17

echo "Compile assessor.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o assessor.o assessor.cpp

echo "Compile isfloat.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o isfloat.o isfloat.cpp

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17

echo "Run the Property Tax Assessor Program:"
./output_file.out
