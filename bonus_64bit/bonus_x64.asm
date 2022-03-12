section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push 	rbp
	mov 	rbp, rsp

	mov r9, rdi 	; v1 address
	mov r10d, esi 	; v1 len
	mov r11, rdx 	; v2 address
	mov r12d, ecx 	; v2 len
	mov r13, r8 	; v address

	push 0 			; nr de elemente deja adaugate din v1
	push 0 			; nr de elemente deja adaugate din v2

	xor rax, rax	; vom pastra in rax nr de alemente adaugate
add_in_v:
	pop r14			; nr de elemente deja adaugate din v2
	pop r15			; nr de elemente deja adaugate din v1
	cmp r15d, r10d	; comparam nr de elemente adaugate din v1 cu lungimea lui v1
	jnl done_with_v1

	mov ebx, dword [r9 + 4 * r15]	; luam elementul din v1
	mov dword [r13 + rax * 4], ebx  ; si il punem in v
	inc r15			; un nou element a fost adaugat din v1
	inc rax			; un nou element a fost adaugat la v

done_with_v1:
	push r15

	cmp r14d, r12d  ; comparam nr de elemente adaugate din v2 cu lungimea lui v2
	jnl done_with_v2

	mov ebx, dword [r11 + 4 * r14]	; luam elementul din v2
	mov dword [r13 + rax * 4], ebx  ; si il punem in v
	inc r14			; un nou element a fost adaugat din v2
	inc rax			; un nou element a fost adaugat la v

done_with_v2:
	push r14

next:
	xor ebx, ebx
	mov ebx, r10d
	add ebx, r12d	; calculam nr de elemente pe care il va avea v la final
	cmp rax, rbx
	jl add_in_v

	sub rsp, 16		; eliberam stiva

	leave
	ret
