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
;    Name:      manager.asm                                                                 *
;    Purpose:   Collects user's name and title, and calls other functions to allow user to  *
;               input values in an array, display the array, calculate the sum and mean of  *
;               the values in the array.                                                    *
;   Assemble:   nasm -f elf64 -l manager.lis -o manager.o manager.asm                       *
;   Link:       g++ -m64 -no-pie -o output_file.out get_assessed_values.o manager.o         *
;               sum_values.o show_property_values.o assessor.o isfloat.o -std=c++17         *
;                                                                                           *
;********************************************************************************************

extern printf
extern fgets
extern stdin
extern strlen
extern isfloat
extern get_assessed_values
extern display_array
extern sum_values

INPUT_LEN equ 64

ARRAY_SIZE equ 100                        ; max array size

global manager

segment .data

    string_format: db "%s", 0

    prompt_name: db "Please enter your name and press enter: ", 0
    prompt_title: db "Please enter your title: ", 0

    thank_you_msg: db "Thank you %s.", 10, 0
    show_values_msg: db "Thank you. Here are the assessed property values in this district.", 10, 0

    display_sum: db "The sum of assessed values is $%.2lf.", 10, 0
    display_mean: db "The mean assessed value is $%.6lf.", 10, 0

    exit_msg_1: db "The mean will now be returned to the caller function.", 10, 0
    exit_msg_2: db "We enjoy serving everyone who is a %s.", 10, 0

segment .bss
    user_name: resb INPUT_LEN
    user_title: resb INPUT_LEN
    array: resq 100                      ; reserve 100 qwords to use as array

segment .text

manager:

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

;========================= Prompt User for Name  ===============================
    mov rax, 0
    mov rdi, string_format          ; "%s"
    mov rsi, prompt_name            ; "Please enter your name and press enter: "
    call printf

;======================== Get User's Name ======================================
    mov rax, 0
    mov rdi, user_name                   ; user_name = user's name will be placed
    mov rsi, INPUT_LEN                   ; A maximum of 64 characters will be read
    mov rdx, [stdin]                     ; Pointer to keyboard input device
    call fgets

    ; Remove "\n" from user_name
    mov rax, 0                           ; 0 xmm registers will be used
    mov rdi, user_name                   ; user_name's length will be checked
    call strlen                          ; places length of user_name in rax

    sub rax, 1                           ; subtract 1 from length of user_name in rax
    mov byte [user_name + rax], 0        ; find the location of "\n" and replace with "\0"

;======================== Prompt User for Title ================================
    mov rax, 0
    mov rdi, string_format               ; "%s"
    mov rsi, prompt_title                ; "Please enter your title: "
    call printf

; ======================= Get User's Title =====================================
    mov rax, 0
    mov rdi, user_title                  ; user_title = user's input for title
    mov rsi, INPUT_LEN                   ; a maximum of 64 characters will be read
    mov rdx, [stdin]                     ; Pointer to keyboard input device
    call fgets

    ; remove "\n" form user_title
    mov rax, 0                           ; 0 xmm registers will be used
    mov rdi, user_title                  ; user_title's length will be checked
    call strlen                          ; places length of user_title in rax

    sub rax, 1                           ; subtract 1 from length of user_title in rax
    mov byte [user_title + rax], 0       ; find the location of "\n" and replace with "\0"

; ========================= Display Thank You Message ==========================
    mov rax, 0
    mov rdi, thank_you_msg              ; "Thank you %s."
    mov rsi, user_name                  ; Displays user's name
    call printf

;========= Call get_assessed_values to input property values into array ========
    mov rax, 0
    mov rdi, array                      ; Passes the array into get_assessed_values
    mov rsi, ARRAY_SIZE                 ; Passes max array size = 100 into get_assessed_values
    call get_assessed_values            ; call get_assessed_values
    mov r15, rax                        ; Stores the number of valid elements user entered in the array

; ============================= Show Property Values ===========================
    ; --------------------- Print Message --------------------------------------
    mov rax, 0
    mov rdi, string_format              ; "%s"
    mov rsi, show_values_msg            ; "Thank you. Here are the assessed property values..."
    call printf

    ; ---------------------- Print the Property Values -------------------------
    ; display_array(double array[], long size)
    mov rax, 0                          ; 0 xmm registers will be used
    mov rdi, array                      ; Array to be displayed
    mov rsi, r15                        ; Size of the array to be displayed
    call display_array                  ; Display the array

; ============================ Sum Up the Assessed Values ======================
    mov rax, 1                          ; 1 xmm register will be used to store returned float
    mov rdi, array                      ; Pass the array whose elements will be summed up
    mov rsi, r15                        ; Pass the size of the array
    call sum_values                     ; Call sum_values that will return the total sum of assessed values
    movsd xmm15, xmm0                   ; xmm15 stores the total sum of the assessed values

; ===================== Display the Sum of the Assessed Values =================
    mov rax, 1                          ; 1 xmm register will be used to pass a float to display_sum
    mov rdi, display_sum                ; "The sum of assessed values is $%.2lf."
    movsd xmm0, xmm15                   ; Total sum of assessed values to be displayed
    call printf

; ======================= Calculate the Mean Assessed Values ===================
    cvtsi2sd xmm14, r15                 ; convert r15 to a float to find the mean
    divsd xmm15, xmm14                  ; Calculates the mean and stores it in xmm15

; =========================== Display the Mean =================================
    mov rax, 1                          ; 1 xmm register will be used
    mov rdi, display_mean               ; "The mean assessed value is $%.6lf."
    movsd xmm0, xmm15                   ; Pass the mean in xmm15 as an argument
    call printf

; ========================== Display Exit Messages =============================
    mov rax, 0
    mov rdi, string_format              ; "%s"
    mov rsi, exit_msg_1                 ; "The mean will now be returned to the caller function."
    call printf

    mov rax, 0
    mov rdi, exit_msg_2                 ; "We enjoy serving everyone who is a %s."
    mov rsi, user_title                 ; Passes the user's title to printf
    call printf

; =================== Return the Mean to the Caller Function ===================
    movsd xmm0, xmm15                   ; Store the mean in xmm0 to return to caller

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
