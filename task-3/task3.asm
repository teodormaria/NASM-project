global get_words
global compare_func
global sort

section .data
	delimitors db " ,.", 10, 0 

section .text
    extern strlen
    extern strcmp
    extern strtok
    extern qsort

compare:    
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp + 8]      ; address of first string
    mov     eax, [eax]
    push    eax
    call    strlen
    add     esp, 4
    push    eax                 ; punem pe stiva lungimea primului string

    mov     ebx, [ebp + 12]     ; address of second string
    mov     ebx, [ebx]
    push    ebx
    call    strlen
    add     esp, 4
    mov     ecx, eax

    pop     edx                 ; vom avea in edx lungimea primului, si in ecx lungimea celui de-al doilea

    sub     edx, ecx
    jnz     exit_compare_different_len

    mov     eax, [ebp + 8]      ; address of first string
    mov     ebx, [ebp + 12]     ; address of second string
    mov     eax, [eax]
    mov     ebx, [ebx]
    push    ebx
    push    eax
    call    strcmp              ; daca au lungimi egale, folosim strcmp sa le comparam
    add     esp, 8
    jmp exit_compare_same_len
    
exit_compare_different_len:
    mov     eax, edx

exit_compare_same_len:          ; in eax va fi deja rezultatul de la strcmp daca au aceeasi lungime
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    push    ebp
    mov     ebp, esp

    mov eax, [ebp + 8]  ; words
    mov ebx, [ebp + 12] ; number_of_words
    mov ecx, [ebp + 16] ; size

    push    compare     ; folosim adresa de la functia scrisa mai sus, compare
    push    ecx
    push    ebx
    push    eax
    call    qsort       ; vom sorta cuvintele apeland qsort
    add     esp, 16
    
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp + 8]  ; stringul s
    mov     ebx, [ebp + 12] ; words
    mov     edx, [ebp + 16] ; number_of_words

    push    delimitors
    push    eax
    call    strtok          ; folosim strtok pentru a imparti in cuvinte
    add     esp, 8
    mov     ebx, [ebp + 12] ; words
    mov     dword [ebx], eax    ; punem in words primul cuvant
    
    mov     ecx, 1
find_word:  
    push    ecx
    push    delimitors
    push    0
    call    strtok          ; dupa prima apelare, apelam strtok cu null, delimitors
    add     esp, 8
    pop     ecx
    mov     ebx, [ebp + 12] ; words
    mov     dword [ebx + 4 * ecx], eax  ; adaugam in words valoarea returnata de strtok

next_word:
    inc     ecx
    mov     edx, [ebp + 16]
    cmp     ecx, edx
    jl      find_word

    leave
    ret
