section .text
	global par
	extern printf

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	pop 	ecx		; return address
	pop 	edi		; str_len
	pop 	esi		; str address
	push 	esi	
	push 	edi
	push 	ecx

	xor 	ecx, ecx
	push	ecx		; pastram in stiva nr de paranteze deschise 
parse:
	xor 	eax, eax
	add 	al, byte [esi + ecx]

	cmp		al, 40			; verificam daca suntem in cazul de paranteze deschise
	jz open_parentheses

	cmp		al, 41			; verificam daca suntem in cazul de paranteze inchise
	jz closed_parantheses

open_parentheses:
	pop 	edx
	add 	edx, 1			; daca este o paranteza deschisa, adaugam 1 la valoarea din stiva
	push 	edx
	jmp 	next

closed_parantheses:
	pop 	edx
	test 	edx, edx		; daca e paranteza inchisa, verificam ca numarul parantezelor deschise de pana acum nu e 0
	jz 		return_0
	sub 	edx, 1			; daca nu e zero, scadem 1, caci o paranteza a fost inchisa
	push 	edx

next:
	add 	ecx, 1
	cmp		ecx, edi
	jl	parse

	pop 	edx
	test	edx, edx		; valoarea finala din stiva ar trebui sa fie 0 pentru ca toate parantezele sa fi fost inchise
	jz		return_1

return_0:
	xor eax, eax
	jmp end

return_1:
	xor eax, eax
	add eax, 1

end:
	ret
