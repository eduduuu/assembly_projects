.intel_syntax noprefix

.section .data
	format_p: .asciz "%d "
	format_s: .asciz "%d"

.section .text
    .global main
    .extern printf
    .extern scanf

main:
	push rbp
	mov rbp, rsp
	sub rsp, 64
	
	// read size

	lea rdi, [format_s]
	lea rsi, [rbp - 4]
	xor eax, eax
	call scanf
	xor eax, eax

	mov DWORD PTR [rbp - 8], 0 

read:
	// read number

	mov eax, DWORD PTR [rbp - 8]
	cdqe
	lea rax, DWORD PTR [rbp + rax*4 - 64]
	mov rsi, rax
	lea rdi, [format_s]
	xor eax, eax
	call scanf
	xor eax, eax

	// check end loop

	mov eax, DWORD PTR [rbp - 8]
	add eax, 1
	mov DWORD PTR [rbp - 8], eax 
	mov ebx, DWORD PTR [rbp - 4]
	cmp eax, ebx
	jne read

	mov DWORD PTR [rbp - 8], 0 	
	
// out loop
sort_out:
	mov DWORD PTR [rbp - 12], 1

// inner loop
sort_in:
	// compare v[i] with v[i-1]
	// and swap if greater	

	mov eax, DWORD PTR [rbp - 12]
	cdqe
 	mov ebx, DWORD PTR [rbp + rax*4 - 64]
	mov eax, DWORD PTR [rbp - 12]
	sub eax, 1
	cdqe
	mov eax, DWORD PTR [rbp + rax*4 - 64]
	cmp eax, ebx
	jg swap

// after swap or if not swap
after_swap:	
	// check end inner loop
	mov eax, DWORD PTR [rbp - 12]
	add eax, 1
	mov DWORD PTR [rbp - 12], eax
	mov ebx, DWORD PTR [rbp - 4]
	cmp eax, ebx
	jne sort_in

	// check end out loop
	mov eax, DWORD PTR [rbp - 8]
	add eax, 1
	mov DWORD PTR [rbp - 8], eax
	cmp eax, ebx
	jne sort_out

	mov DWORD PTR [rbp - 8], 0
	jmp print 

// swaps v[i] and v[i-1
swap:
	mov ecx, eax
	mov eax, DWORD PTR [rbp - 12]
	cdqe
	mov DWORD PTR [rbp + rax*4 - 64], ecx
	sub eax, 1
	cdqe
	mov DWORD PTR [rbp + rax*4 - 64], ebx
	jmp after_swap

// print the array
print:
	//print

	mov eax, DWORD PTR [rbp - 8]
	cdqe
	mov eax, DWORD PTR [rbp + rax*4 - 64]
	mov esi, eax
	lea rdi, [format_p]
	xor eax, eax
	call printf
	xor eax, eax

	// check end array

	mov eax, DWORD PTR [rbp - 8]
	add eax, 1
	mov DWORD PTR [rbp - 8], eax 
	mov ebx, DWORD PTR [rbp - 4]
	cmp eax, ebx
	jne print

	// end program

	xor eax, eax
	leave
	ret
