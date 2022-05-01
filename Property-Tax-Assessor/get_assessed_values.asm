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
;   Name:       get_assessed_values.asm                                                     *
;   Purpose:    Allows user to input property values into an array while checking for       *
;               floating-point number validation.                                           *
;   Assemble:   nasm -f elf64 -l get_assessed_values.lis -o get_assessed_values.o get_assessed_values.asm *
;   Link:       g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o         *
;               sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17         *
;                                                                                           *
;********************************************************************************************

extern printf
extern scanf
extern isFloat
extern atof

global get_assessed_values

segment .data

    string_format: db "%s", 0

    directions:
      db "Next we will collect the property values in your assessment district. ",
      db "Between each value enter white space. ",
      db "When finished entering values press <enter> followed by control+D.", 10, 0

    invalid_input: db "The last input was invalid and will not be added to the array.", 10, 0

segment .bss

segment .text

get_assessed_values:

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

; ========================= INITIALIZE PARAMETERS ==============================
    mov r15, rdi                      ; Address of array stored in r15
    mov r14, rsi                      ; Max number of elements allowed in array
    mov r13, 0                        ; Set counter to 0 elements in array

; ==================== Display Instructions to enter floats ====================
    mov rax, 0
    mov rdi, string_format            ; "%s"
    mov rsi, directions               ; "Next we will collect the property ..."
    call printf

; ============================ Start of Loop ===================================
begin_loop:

    ; ------------------- Determine if Max Capacity Reached --------------------
    cmp r13, r14                      ; if index counter == max array size
    je exit                           ; exit the program, max array size reached

    ; -------------------- Take in a float from the user -----------------------
    push qword 0                       ; extra qword pushed for stack alignment
    push qword 0                       ; push a qword to store user-input

    mov rax, 0
    mov rdi, string_format             ; "%s"
    mov rsi, rsp                       ; Place pointer to the top of the stack
    call scanf

    ; -------------------- Check if user pressed Ctrl+D ------------------------
    cdqe                               ; use cdqe to store the -1 from eax to rax
    cmp rax, -1                        ; compare rax with -1
    je end_loop                        ; if rax == -1 then jump to end of loop

    ; ------------- Determine if value entered is a float ----------------------
    mov rax, 0
    mov rdi, rsp                      ; Pass pointer to the top of the stack were user-inputted value is stored
    call isFloat                      ; call isFloat to determine if value is a valid float

    cmp rax, 0                        ; If a float is invalid, isFloat will return 0 in rax
    je invalid_float                  ; If rax == 0, jump to invalid_float

    ; --------------- Convert User-Inputted Value to Float ---------------------
    mov rax, 1                        ; 1 xmm register will be used
    mov rdi, rsp                      ; Use float from the top of the stack
    call atof                         ; convert user-inputted value to float
    movsd xmm15, xmm0                 ; store float in xmm15

    pop r8                            ; pop float that rsp was pointing to
    pop r8                            ; extra pop for stack alignment

    ; ------------------- Copy Float to Array ----------------------------------
    movsd [r15 + 8 * r13], xmm15      ; Store float in xmm15 to the array at index r13 of the array
    inc r13                           ; Increment index counter r13

    ; ---------------------- Restart Loop --------------------------------------
    jmp begin_loop

; ============================= INVALID FLOAT ==================================
invalid_float:
    ; This block discards the invalid inputs and continues processing the remaining data.

    pop r8                             ; Pop the user-inputted value from the top of the stack to r8
    pop r8                             ; Extra pop for stack alignment

    mov rax, 0
    mov rdi, string_format             ; "%s"
    mov rsi, invalid_input             ; "The last input was invalid and will not be added to the array."
    call printf

    jmp begin_loop                    ; jump to the begining of the loop

; ========================== End of Loop =======================================
end_loop:
    pop r8                            ; Pop the top of the stack
    pop r8                            ; Extra pop for stack alignment

; ============================== Exit ==========================================
exit:
    mov rax, r13                      ; Return the size of the array (# of valid elements user entered)

;============ Restore original values to integer registers =====================
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
