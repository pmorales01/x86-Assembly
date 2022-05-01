//****************************************************************************************************************************
//Program name: "Quadratic". This program takes in 3 float numbers as coefficients to determine whether or not they fit the
//criteria for a quadratic equation. It will calculate the discriminant and validate input to find roots or let the user know
//there is no root. Copyright (C) 2021 Johnson Tong.
//                                                                                                                           *
//This file is part of the software program "Quadratic".                                                                     *
//Quadratic is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License     *
//version 3 as published by the Free Software Foundation.                                                                    *
//Quadratic is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied            *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Johnson Tong
//  Author email: jt28@csu.fullerton.edu
//
//Purpose
//  This file contains the function isFloat that will check whether or not a string input is a float. 
//
//This file
//   File name: isFloat.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -no-pie -m64 -std=c++17 -o isFloat.o isFloat.cpp
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================


#include <iostream>

extern "C" bool isFloat(char [ ]);

bool isFloat(char w[ ])
{   bool result = true;
    bool onepoint = false;
    int start = 0;
    if (w[0] == '-' || w[0] == '+') start = 1;
    unsigned long int k = start;
    while (!(w[k] == '\0') && result )
    {    if (w[k] == '.' && !onepoint)
               onepoint = true;
         else
               result = result && isdigit(w[k]) ;
         k++;
     }
     return result && onepoint;
}
