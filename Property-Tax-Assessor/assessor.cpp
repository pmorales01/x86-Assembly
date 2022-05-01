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
//   Name:       assessor.cpp                                                                *
//   Purpose:    Caller function for the Property Tax Assessor program. Calls manager.asm    *
//               and displays the mean assessed value returned from manager.asm              *
//   Compile:    g++ -c -Wall -no-pie -m64 -std=c++17 -o assessor.o assessor.cpp             *
//   Link:       g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o         *
//               sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17         *
//                                                                                           *
//********************************************************************************************

#include <stdio.h>
#include <time.h>
#include <stdint.h>

extern "C" double manager();

int main(int argc, char*argv[]) {
  //Obtain and display the Linux time in the present machine.
  time_t current_linux_time;
  current_linux_time = time(NULL);

  //Use the Linux time computed immediately above and convert it to broken time
  // (human manageable time) in current time zone.
  struct tm * broken = localtime(&current_linux_time);

  const char * month[] = {"January", "February", "March", "April", "May", "June",
                          "July", "August", "September", "October", "November", "December"};

  printf("Welcome to the Orange County Property Assessment Office on %s %02d, %04d\n",
                                                          month[broken->tm_mon],
                                                          broken->tm_mday,
                                                          broken->tm_year+1900);

  printf("For assistance contact Pedro Morales at pedromorales@premier.com\n");

  // Returns the total assessed value of all the property in a given district
  double property_tax = manager();

  printf("The Assessor’s Office received this number %.2lf and will keep it.\n", property_tax);
  printf("Next an integer 0 will be sent to the operating system as a signal of successful completion.\n");
  return 0;
}
