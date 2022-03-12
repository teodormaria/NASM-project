section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	pop 	ecx		; return address
	pop 	edi		; in edi vom pastra o copie a lui a
	pop 	esi		; in edi vom pastra o copie a lui b
	push	esi		; adaugam din nou b initial in stiva
	push 	esi	
	push 	edi
	push 	ecx

divide_again:
	xor		ecx, ecx
	add 	ecx, 2		; cand vom cauta divizori, vom incepe mereu de la 2
find_divisors:
	xor 	eax, eax
	xor 	edx, edx
	add		eax, edi
	div 	ecx
	
	xor		ebx, ebx
	add		ebx, eax

	test	edx, edx	; verificam daca dupa impartire restul este zero
	jz		test_b		; dupa ce gasim un divizor al lui a, verificam daca este si divizor al lui b
	jmp		next

test_b:
	xor 	eax, eax
	xor 	edx, edx
	add		eax, esi
	div 	ecx
	test	edx, edx
	jnz		next

	pop 	ecx		; return address
	pop 	edi		; a
	pop 	esi		; b
	xor		esi, esi
	add		esi, eax	; daca am gasit un divizor comun, impartim si esi si edi la el
	xor		edi, edi
	add		edi, ebx
	push 	esi	
	push 	edi
	push 	ecx
	jmp 	divide_again

next:
	add 	ecx, 1
	cmp		ecx, edi
	jl		find_divisors

	pop 	ecx		; return address
	pop 	edi		; a
	pop 	esi		; b
	pop		eax		; scoatem b initial in stiva
	push 	esi	
	push 	edi
	push 	ecx

	mul		edi		; cmmmc va fi b-ul initial inmultit cu ramane dupa impartiri din a

end:	
	ret
