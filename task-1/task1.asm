section .text
	global sort
; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	push    ebp
    mov     ebp, esp

    mov     ebx, [ebp + 8]  ; len
    mov     edx, [ebp + 12] ; node array address

	xor esi, esi
parse:						; label pus pentru a gasi elementul minim de n ori
	xor 	eax, eax
	push 	eax 			; o sa pastrez pe stiva pozitia elementului minim 
	mov		eax, 0x7fffffff ; eax va pastra valoarea minima gasita, deci e 
							; initializat cu valoarea maxima pt signed int

	xor 	ecx, ecx	
get_min:
	mov 	edx, [ebp + 12]
	mov 	ebx, dword [edx + 8 * ecx + 4]	; node next

	test	ebx, ebx		; daca next nu are valoarea null elementul a fost deja gasit
	jnz 	next_node_min

	mov 	ebx, dword [edx + 8 * ecx] 		; node val
	cmp		ebx, eax
	jnl		next_node_min

	pop 	edx
	push 	ecx 			; indexul nodului cu valoarea minima
	mov 	eax, ebx
	jmp next_node_min

next_node_min:
	add		ecx, 1
	mov		ebx, [ebp + 8]
	cmp 	ecx, ebx
	jne 	get_min

	mov 	ebx, [ebp + 8]	; verific daca s-a ajuns la ultimul nod, care va avea next null
	sub		ebx, 1
	cmp		ebx, esi
	je		after_dummy

add_dummy:
	pop 	eax				; new min
	push 	eax
	mov 	edx, [ebp + 12]
	mov 	dword [edx + 8 * eax + 4], 1 ; vom pune in node next valoarea 1 
						; pentru a nu fi gasit din nou drept element minim

after_dummy:			; in cazul ultimului nod, nu avem nevoie de dummy next
	test 	esi, esi
	jnz 	not_first
	pop		eax			
	mov		dword [ebp - 16], eax ; vom pastra la ebp - 16 valoarea indicelui primului element
	push 	eax
	jmp		next_parse

not_first:
	pop 	eax	; new min
	pop		ebx	; previous min, ramas in stiva
	push 	eax	; nu vom pastra valoarea previous min pe stiva
	xor		edx, edx
	mov 	ecx, 8	; dimensiunea structurii
	mul		cx
	shl		edx, 16	; in dx se afla primii 2 octeti ai rezultatului inmultirii
	add 	eax, edx	
	mov 	edx, [ebp + 12]
	add 	eax, edx
	mov 	[edx + 8 * ebx + 4], eax ; node next

next_parse:
	add 	esi, 1
	mov		ebx, [ebp + 8]
	cmp 	esi, ebx
	jne 	parse


	pop		ebx						; golim stiva
	mov 	eax, dword [ebp - 16]	; luam indexul nodului cu valoarea minima
	mov 	ecx, 8
	xor 	edx, edx
	mul		cx						; inmultim indexul cu dimensiunea structurii
	shl 	edx, 16
	add		eax, edx				; pastram in eax rezultatul inmultirii
	mov		edx, [ebp + 12]
	add 	eax, edx				; adunam la eax adresa inceputului vectorului

	leave
	ret
