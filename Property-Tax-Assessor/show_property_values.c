//********************************************************************************************
// Program name:          Property Tax Assessor                                              *
// Programming Language:  x86 Assembly                                                       *
// Program Description:   This program asks a user to input floats into an array and then    *
//                        the sum and mean of all the elements in the array is found.        *
//                                                                                           *
//********************************************************************************************
// Author Information:                                                                       *
// Name:         Pedro Morales                                                               *
// Email:        pedrom2@csu.fullerton.edu                                                   *
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
//********************************************************************************************
// Program information                                                                       *
//   Program name: Property Tax Assessor                                                     *
//   Programming languages: One module in C, Three modules in X86, Two modules in C++        *
//   Files in this program: manager.asm get_assessed_values.asm sum_values.asm               *
//                          show_property_values.c assessor.cpp isfloat.cpp                  *
//                                                                                           *
//********************************************************************************************
// This File                                                                                 *
//   Name:       show_property_values.c                                                      *
//   Purpose:    Displays all the elements in the array.                           *         *
//   Compile:    gcc -c -Wall -m64 -no-pie -o show_property_values.o show_property_values.c -std=c17 *
//   Link:       g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o         *
//               sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17         *
//                                                                                           *
//********************************************************************************************

#include <stdio.h>

extern void display_array(double array[], long size);

void display_array(double array[], long size)
{
    printf("\n");
    for (int i = 0; i < size; ++i)
    {
        printf("%.2lf", array[i]);
        printf("\n");
    }
    printf("\n\n");
}
