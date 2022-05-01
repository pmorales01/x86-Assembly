;********************************************************************************************
; Program name:          Harmonic Sum                                                       *
; Programming Language:  x86 Assembly                                                       *
; Program Description:   This program asks a user to input a number of terms to calculate   *
;                        the harmonic sum for and calculates elapsed time while the         *
;                        harmonic sum is being calculated.                                  *
;                                                                                           *
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Pedro Morales                                                               *
; Email:        pedrom2@csu.fullerton.edu                                                   *
; Class:        CPSC 240-07                                                                 *
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
;   Program name: Harmonic Sum                                                              *
;   Programming languages: One module in C, Three modules in X86, One module in C++         *
;   Files in this program: manager.asm compute_sum.asm clock_speed.asm                      *
;                          output_one_line.c harmonic.cpp                                   *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;   Name:       compute_sum.asm                                                             *
;   Purpose:    Computes the harmonic sum for the number of terms the user entered,         *
;               output_one_line.c is called to print out the Intermediate sum values, and   *
;               the harmonic sum is returned to the manager module.                         *
;   Assemble:   nasm -f elf64 -l compute_sum.lis -o compute_sum.o compute_sum.asm           *
;   Link:       g++ -m64 -no-pie -o final.out manager.o compute_sum.o clock_speed.o         *
;               harmonic.o output_one_line.o -std=c++17                                     *
;                                                                                           *
;********************************************************************************************
extern output_one_line
extern printf

global compute_sum

segment .data
    string_format: db "%s", 0
    term_sum_header: db "Term#		   Sum", 10, 0
    display_sum: db "The sum of %ld terms is %.10lf", 10, 0

segment .bss

segment .text

compute_sum:
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

; =========================== Initialize Parameters ===========================
    mov r15, rdi                        ; store the number of terms, n, user entered in r15
    xorpd xmm15, xmm15                  ; zero out xmm15 to store sum
    mov r14, 1                          ; store 1 in r14, will be used as loop counter for current term

    ; ---------------- Store 1.0 in xmm14 --------------------------------------
    mov rax, 1                          ; store 1 in rax
    cvtsi2sd xmm14, rax                 ; convert 1 to 1.0 and store in xmm14

; ========== Print Term and Sum Header for Intermediate Value ==================
    mov rax, 0
    mov rdi, string_format              ; "%s"
    mov rsi, term_sum_header            ; "Term#		   Sum"
    call printf

; ========================== Start of Loop =====================================
begin_loop:
    ; -------------- Determine if the nth Term Has Been Reached ----------------
                                        ; r14 = loop count, r15 = n
    cmp r14, r15                        ; compare loop count with the number of terms user entered
    jg end_loop                         ; if loop count is greater than n, jump to end of loop

    ; ----------- Calculate 1 / current term and Add to Total Sum---------------
    cvtsi2sd xmm12, r14                 ; convert loop count to a float
    movsd xmm11, xmm14                  ; copy 1.0 from xmm14 and store it in xmm11
    divsd xmm11, xmm12                  ; calculate 1.0 / n (float) and store it in xmm11
    addsd xmm15, xmm11                  ; add the sum stored in xmm11 to the total sum in xmm15

    ; --------------------- Call output_one_line -------------------------------
    mov rax, 1                          ; 1 xmm register will be used
    mov rdi, r14                        ; Pass loop count to the 1st parameter of output_one_line
    movsd xmm0, xmm15                   ; Pass sum to the 2nd parameter of output_one_line
    mov rsi, r15                        ; Pass number of terms to the 3rd parameter of output_one_line
    call output_one_line

    ; ------------------ Increment Loop Count and Loop Again -------------------
    inc r14                             ; increment loop count
    jmp begin_loop                      ; jump to the beginning of loop

; ========================= End of Loop ========================================
end_loop:
    ; ---------------------- Display Sum ---------------------------------------
    mov rax, 1                          ; 1 xmm register will be used
    mov rdi, display_sum                ; "The sum of %ld terms is %.10lf"
    mov rsi, r15                        ; Pass number of terms to the 1st parameter
    movsd xmm0, xmm15                   ; Pass sum to the 2nd parameter
    call printf

    ; -------------------- Return Harmonic Sum to manager ----------------------
    movsd xmm0, xmm15                   ; Return the harmonic sum stored in xmm15

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
