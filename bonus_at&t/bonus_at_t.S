/*
 * Don't forget to include "positions.h"
 */
#include "positions.h"
.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */
.macro substract  position, value
	movl 	\position, %eax
	movl	0x10(%ebp), %ebx
	mulb	%bl							
	xorl 	%edx, %edx
	movl 	$10, %ebx
	divw	%bx						# scalam pentru n pozitia (pozitia*n/10)
	movl 	0x14(%ebp), %ebx
	movl	(%ebx, %eax, 0x4), %edx
	movl	\value, %ecx
	subl	%ecx, %edx				# scadem valoarea din ce se afla deja la pozitia scalata
	movl	%edx, (%ebx, %eax, 0x4)	# punem rezultatul in v
.endm

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp

	xorl 	%ecx, %ecx					# contor ce va lua valori pana la n
add_arrays:
	movl 	0x8(%ebp), %eax
	movl	0xc(%ebp), %ebx
	movl 	(%eax, %ecx, 0x4), %edx
	movl	(%ebx, %ecx, 0x4), %eax
	addl	%edx, %eax					# adaugam valoarea de la pozitia i din v1 cu cea din v2
	movl	0x14(%ebp), %ebx
	movl	%eax, (%ebx, %ecx, 0x4)		# punem in v valoarea obtinuta
next:
	incl	%ecx
	movl	0x10(%ebp), %eax
	cmpl	%eax, %ecx
	jl		add_arrays

substracting:

	substract $FIRST_POSITION, $FIRST_VALUE		# apelam macroul pt cele 3 pozitii
	substract $SECOND_POSITION, $SECOND_VALUE
	substract $THIRD_POSITION, $THIRD_VALUE

	leave
	ret
