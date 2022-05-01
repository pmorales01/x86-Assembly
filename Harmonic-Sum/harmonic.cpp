//********************************************************************************************
// Program name:          Harmonic Sum                                                       *
// Programming Language:  x86 Assembly                                                       *
// Program Description:   This program asks a user to input a number of terms to calculate   *
//                        the harmonic sum for and calculates elapsed time while the         *
//                        harmonic sum is being calculated.                                  *
//                                                                                           *
//********************************************************************************************
// Author Information:                                                                       *
// Name:         Pedro Morales                                                               *
// Email:        pedrom2@csu.fullerton.edu                                                   *
// Class:        CPSC 240-07                                                                 *
//                                                                                           *
//********************************************************************************************
// Copyright (C) 2022 Pedro Morales                                                          *
// This program is free software: you can redistribute it and/or modify it under the terms   *
// of the GNU General Public License version 3 as published by the Free Software Foundation. *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
// without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *
// See the GNU General Public License for more details. A copy of the GNU General Public     *
// License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//                                                                                           *
// Program information                                                                       *
// Program name: Harmonic Sum                                                              *
// Programming languages: One module in C, Three modules in X86, One module in C++         *
// Files in this program: manager.asm compute_sum.asm clock_speed.asm                      *
//                        output_one_line.c harmonic.cpp                                   *
//                                                                                           *
//********************************************************************************************
// This File                                                                                 *
//   Name:       harmonic.cpp                                                                *
//   Purpose:    Caller function for the Harmonic Sum program. Calls manager.asm             *
//               and displays the harmonic sum returned from manager.asm.                    *
//   Compile:    g++ -c -Wall -no-pie -m64 -std=c++17 -o harmonic.o harmonic.cpp             *
//   Link:       g++ -m64 -no-pie -o final.out manager.o compute_sum.o clock_speed.o         *
//               harmonic.o output_one_line.o -std=c++17                                     *
//                                                                                           *
//********************************************************************************************

#include <stdio.h>

extern "C" double manager();

int main(int argc, char*argv[]) {
  printf("Welcome to Harmonic Sum created by author Pedro Morales.\n");

  double sum = manager();

  printf("The main function received %.10lf and will keep it.\n", sum);

  return 0;
}
