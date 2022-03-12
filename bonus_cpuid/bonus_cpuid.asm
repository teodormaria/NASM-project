section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	push 	ebp
	mov 	ebp, esp
	pusha

	xor 	eax, eax	; daca in eax se afla 0, cpuid va pune in ebx, edx si ecx manufacturer id string
	cpuid

	mov 	eax, [ebp + 8]
	mov 	dword [eax], ebx
	mov 	dword [eax + 4], edx
	mov 	dword [eax + 8], ecx

	popa
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	push 	ebp
	mov 	ebp, esp
	pusha

	mov		eax, 1	; daca in eax se afla 1, in ecx cpuid va pune informatii despre features
	cpuid
	mov 	ebx, 1
	shl 	ebx, 5
	and 	ebx, ecx	; pe al 5-lea bit din ecx se va afla daca exista sau nu vmx
	mov		edx, [ebp + 8]
	test	ebx, ebx
	jz		no_vmx
	mov 	dword [edx], 1
	jmp		check_rdrand
no_vmx:
	mov 	dword [edx], 0

check_rdrand:
	mov 	ebx, 1
	shl 	ebx, 30
	and 	ebx, ecx	; pe al 30-lea bit din ecx se va afla daca exista sau nu rdrand
	mov		edx, [ebp + 12]
	test	ebx, ebx
	jz		no_rdrand
	mov 	dword [edx], 1
	jmp		check_avx
no_rdrand:
	mov 	dword [edx], 0

check_avx:
	mov 	ebx, 1
	shl 	ebx, 28
	and 	ebx, ecx	; pe al 28-lea bit din ecx se va afla daca exista sau nu avx
	mov		edx, [ebp + 16]
	test	ebx, ebx
	jz		no_avx
	mov 	dword [edx], 1
	jmp		end
no_avx:
	mov 	dword [edx], 0

end:
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	push 	ebp
	mov 	ebp, esp
	pusha

	mov 	eax, 80000006h	; daca in eax se afla valoarea asta, in ecx vor fi puse l2_cache_info
	cpuid
	mov 	eax, [ebp + 8]
	mov 	ebx, ecx
	and 	ebx, 0xff		; bitii [7:0] din ecx sunt l2 cache line size in bytes
	mov 	dword[eax], ebx
	
	mov 	eax, [ebp + 12]
	mov 	ebx, ecx
	shr 	ebx, 16
	and 	ebx, 0xffff		; bitii [31:16] din ecx sunt l2 cache size in KB
	mov 	dword[eax], ebx

	popa
	leave
	ret
