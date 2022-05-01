#!/bin/bash

#Author: Pedro Morales
#Program name: Harmonic Sum
#Purpose: This is a Bash script file whose purpose is to compile and run the program "Harmonic Sum".

#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble compute_sum.asm"
nasm -f elf64 -l compute_sum.lis -o compute_sum.o compute_sum.asm

echo "Assemble clock_speed.asm"
nasm -f elf64 -l clock_speed.lis -o clock_speed.o clock_speed.asm

echo "Compile harmonic.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o harmonic.o harmonic.cpp

echo "Compile output_one_line.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o output_one_line.o output_one_line.c -std=c17

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o final.out manager.o compute_sum.o clock_speed.o harmonic.o output_one_line.o -std=c++17

echo "Run the Harmonic Sum Program:"
./final.out
