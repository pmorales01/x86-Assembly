;********************************************************************************************
; Program name:          Property Tax Assessor                                              *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input floats into an array and then    *
;                        the sum and mean of all the elements in the array is found.        *
;                                                                                           *
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Pedro Morales                                                               *
; Email:        pedrom2@csu.fullerton.edu                                                   *
;                                                                                           *
;********************************************************************************************
; Copyright (C) 2022 Pedro Morales                                                          *
; This program is free software: you can redistribute it and/or modify it under the terms   *
; of the GNU General Public License version 3 as published by the Free Software Foundation. *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;                                                                                           *
;********************************************************************************************
; Program information                                                                       *
;   Program name: Property Tax Assessor                                                     *
;   Programming languages: One module in C, Three modules in X86, Two modules in C++        *
;   Files in this program: manager.asm get_assessed_values.asm sum_values.asm               *
;                          show_property_values.c assessor.cpp isfloat.cpp                  *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;   Name:       sum_values.asm                                                              *
;   Purpose:    Returns the sum of all the elements in the array.                           *
;   Assemble:   nasm -f elf64 -l sum_values.lis -o sum_values.o sum_values.asm              *
;   Link:       g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o         *
;               sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17         *
;                                                                                           *
;********************************************************************************************

global sum_values

segment .data

segment .bss

segment .text

sum_values:

    push rbp ; Push memory address of base of previous stack frame onto stack top

    mov rbp, rsp ; Copy value of stack pointer into base pointer,
    ; rbp = rsp = both point to stack top
    ; Rbp now holds the address of the new stack frame, i.e "top" of stack
    push rdi ; Backup rdi
    push rsi ; Backup rsi
    push rdx ; Backup rdx
    push rcx ; Backup rcx
    push r8 ; Backup r8
    push r9 ; Backup r9
    push r10 ; Backup r10
    push r11 ; Backup r11
    push r12 ; Backup r12
    push r13 ; Backup r13
    push r14 ; Backup r14
    push r15 ; Backup r15
    push rbx ; Backup rbx
    pushf ; Backup rflags

; ============================ Initialize Parameters ===========================
    mov r15, rdi                        ; Address of the array stored in r15
    mov r14, rsi                        ; Number of elements in the array
    mov r13, 0                          ; Counter set to 0 elements in the array
    xorpd xmm15, xmm15                  ; Zero out xmm15, will store the total sum of property values
; ============================= Start of Loop ==================================
begin_loop:

    ; -------------- Determine if max array size has been reached --------------
    cmp r13, r14                        ; compare index counter and array size
    je exit                             ; if equal, jump to exit to end the loop

    ; ------------- Obtain values from index r13 in the array ------------------
    movsd xmm14, [r15 + 8 * r13]        ; store the value at the r13th element in xmm14

    ; ------------------- Add the Value to the Total Sum -----------------------
    addsd xmm15, xmm14                  ; Add xmm14 to the total sum

    inc r13                             ; Increment the loop counter

    ; ---------------------- Restart the loop ----------------------------------
    jmp begin_loop

; ============================== Exit the Loop =================================
exit:
    ; -------------------- Return Sum to the Manager ---------------------------
    movsd xmm0, xmm15                   ; store xmm15 into xmm0

;============ Restore original values to integer registers ======================================
    popf                                                        ;Restore rflags
    pop rbx                                                     ;Restore rbx
    pop r15                                                     ;Restore r15
    pop r14                                                     ;Restore r14
    pop r13                                                     ;Restore r13
    pop r12                                                     ;Restore r12
    pop r11                                                     ;Restore r11
    pop r10                                                     ;Restore r10
    pop r9                                                      ;Restore r9
    pop r8                                                      ;Restore r8
    pop rcx                                                     ;Restore rcx
    pop rdx                                                     ;Restore rdx
    pop rsi                                                     ;Restore rsi
    pop rdi                                                     ;Restore rdi
    pop rbp                                                     ;Restore rbp

    ret
