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
;   Name:       manager.asm                                                                 *
;   Purpose:    Calls the appropriate functions to calculate the harmonic sum, time elapsed *
;               in tics and seconds, and returns the harmonic sum to the caller module.     *
;   Assemble:   nasm -f elf64 -l manager.lis -o manager.o manager.asm                       *
;   Link:       g++ -m64 -no-pie -o final.out manager.o compute_sum.o clock_speed.o         *
;               harmonic.o output_one_line.o -std=c++17                                     *
;                                                                                           *
;********************************************************************************************
extern printf
extern scanf
extern compute_sum
extern clock_speed

global manager

segment .data
    string_format: db "%s", 0
    int_format: db "%ld", 0
    float_format: db "%lf", 0

    prompt_terms: db "How many terms do you want to include? ", 0

    start_tics: db "Thank you.  The time is now %ld tics.", 10, 0
    end_tics: db "The time is now %ld tics", 10, 0
    elapsed_tics: db "The elapsed time is %ld tics", 10, 0
    message: db "The computation has begun.", 10, 0
    elapsed_seconds: db "The elapsed time equals %.11lf seconds", 10, 0
    exit_msg: db "The sum will be returned to the caller module.", 10, 0
    ask_freq: db "An AMD processor was detected.  Please enter your processor frequency in GHz: ", 10, 0

segment .bss

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

; ============= Prompt User to Enter Number of Terms to Calculate =============
    mov rax, 0
    mov rdi, string_format              ; "%s"
    mov rsi, prompt_terms               ; "How many terms do you want to include?"
    call printf

; ========= Call scanf to Get Number of Terms to Calculate from User ===========
    push qword 0                       ; push extra qword for stack alignment
    push qword 0                       ; push qword for the 1 integer that will be entered by user

    mov rax, 0
    mov rdi, int_format                ; "%ld"
    mov rsi, rsp                       ; Place pointer to the top of the stack
    call scanf

    pop r15                            ; pop int from top of stack and store its value in r15
    pop rax                            ; pop a qword for extra qword pushed

; ===================== Get the Start Time in tics  ============================
    mov rax, 0                         ; place 0's in rax to clear out any previously stored values
    mov rdx, 0                         ; place 0's in rdx to clear out any previously stored values
    cpuid                              ; use cpuid to obtain cpu information
    rdtsc                              ; use rdtsc to read time-stamp counter and retrieve tics
    shl rdx, 32                        ; shift the lower 32-bits of rdx to the upper half of rdx
    add rdx, rax                       ; add the lower 32 bits of rax to rdx
    mov r14, rdx                       ; store the number of tics stored in rdx to r14

; ===================== Display the Start Time in Tics =========================
    mov rax, 0
    mov rdi, start_tics                ; "Thank you. The time is now %ld tics."
    mov rsi, r14                       ; r14 = start time in tics
    call printf

; =================== Display Message that Computation Has Begun ===============
    mov rax, 0
    mov rdi, string_format             ; "%s"
    mov rsi, message                   ; "The computation has begun."
    call printf

; ================== Call compute_sum to Calculate Harmonic Sum ================
    mov rax, 0
    mov rdi, r15                       ; Pass number of terms user entered to 1st parameter
    call compute_sum
    movsd xmm15, xmm0                  ; Store the returned sum from calling compute_sum() to xmm15

; ======================= Get the End Time in Tics =============================
    mov rax, 0                         ; clear out any previously stored values in rax
    mov rdx, 0                         ; clear out any previously stored values in rdx
    cpuid                              ; obtain cpu information
    rdtsc                              ; retrieve tics
    shl rdx, 32                        ; shift the lower 32-bits of rdx
    add rdx, rax                       ; add the lower 32 bits of rax to rdx
    mov r13, rdx                       ; store number of tics stored in r13

; ================== Display the End Time in Tics ==============================
    mov rax, 0
    mov rdi, end_tics                  ; "The time is now %ld tics"
    mov rsi, r13                       ; r13 = end time in tics
    call printf

; ============== Calculate and Print the Elapsed Time in Tics ==================
    ; r14 = beginning tics
    ; r13 = end tics

    sub r13, r14                      ; r13 = end - beginning tics

    mov rax, 0
    mov rdi, elapsed_tics             ; "The elapsed time is %ld tics"
    mov rsi, r13                      ; r13 = elapsed tics
    call printf

; =============== Call clock_speed() to Get Processor Frequency ================
    mov rax, 0
    call clock_speed                  ; call clock_speed to obtain processor frequency
    movsd xmm14, xmm0                 ; Store frequency received in xmm14

; ======== Ask User for Processor Frequency if clock_speed() returns 0.0 =======
    xorpd xmm11, xmm11                ; zero out xmm11 to store 0.0
    ucomisd xmm14, xmm11              ; compare frequency stored in xmm14 to 0.0
    je ask_user                       ; if the frequency is equal to 0.0, then an AMD processor was detected

    jmp calculate_seconds             ; jump to section calculate_seconds since frequency is not 0.0

ask_user:
    ; ------------- Prompt User to Enter Processor Frequency -------------------
    mov rax, 0
    mov rdi, string_format            ; "%s"
    mov rsi, ask_freq                 ; "An AMD processor was detected.  Please enter your processor frequency in GHz: "
    call printf

    ; ------------ Get Processor Frequency from User Using scanf ---------------
    push qword 0                       ; push extra qword for stack alignment
    push qword 0                       ; push qword for the 1 float that will be entered by user

    mov rax, 0
    mov rdi, float_format              ; "%lf"
    mov rsi, rsp                       ; Place pointer to the top of the stack
    call scanf

    movsd xmm14, [rsp]                 ; dereference the top of the stack and store the float in xmm14

    pop rax                            ; pop a qword for each qword pushed
    pop rax

; ================ Divide Elapsed Tics by Processor Frequency ==================
calculate_seconds:
    ; r13 = elapsed tics
    ; xmm14 = processor frequency

    cvtsi2sd xmm13, r13               ; convert elapsed tics to float and store in xmm13
    divsd xmm13, xmm14                ; xmm13 = elapsed tics / processor frequency

; ================== Convert Elapsed Time to Seconds ===========================
    mov rax, 0x41cdcd6500000000       ; Place 1 billion in IEEE in rax
    movq xmm14, rax                   ; Place value of rax in xmm14
    divsd xmm13, xmm14                ; xmm13 = (elapsed tics / frequency) / 1 billion

; ==================== Display Elapsed Time in Seconds =========================
    mov rax, 1
    mov rdi, elapsed_seconds          ; "The elapsed time equals %.11lf seconds"
    movsd xmm0, xmm13                 ; Pass elapsed seconds to 2nd parameter
    call printf

; ========================== Display Exit Message ==============================
    mov rax, 0
    mov rdi, string_format            ; "%s"
    mov rsi, exit_msg                 ; "The sum will be returned to the caller module."
    call printf

; ================ Return Harmonic Sum to the Driver Function ==================
    movsd xmm0, xmm15                 ; Return harmonic sum

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
