section .text

global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        
        mov     eax, [ebp + 8]          ; p
        mov     ebx, [ebp + 12]         ; i
        mov     esi, dword [ebx]        ; *i - current position
        xor     ecx, ecx
        mov     cl, byte [eax + esi]
        cmp     ecx, 40                 ; verificam daca pozitia curenta indica spre '('
        jnz     number

        inc     esi
        mov     dword [ebx], esi
        push    ebx
        push    eax
        call    expression              ; daca este (expression), chemam functia expression
        add     esp, 8
        mov     ebx, [ebp + 12]
        mov     esi, dword [ebx]
        inc     esi                     ; mai adaugam 1 la *i, pentru a trece si de ')'
        mov     dword [ebx], esi
        jmp exit_factor                 ; in eax se va afla rezultatul expresiei

number:
        sub     ecx, 48         ; in ecx este prima cifra, scadem 48 cat sa obtinem valoarea acesteia
        push    ecx             ; vom pastra pe stiva numarul obstinut
next_digit:
        inc     esi             ; ne mutam la urmatorul caracter
        mov     eax, [ebp + 8]  ; p
        xor     ecx, ecx
        mov     cl, byte [eax + esi]    ; ecx contine valoarea ascii a urmatorului caracter
        cmp     ecx, 48         ; comparam cu valoarea ascii a lui 0
        jl      end_of_number
        cmp     ecx, 57         ; comparam cu valoarea ascii al lui 9
        jg      end_of_number
        sub     ecx, 48         ; obtinem valoarea buna a numarului
        pop     eax
        xor     edx, edx
        mov     ebx, 10
        mul     ebx             ; inmultim valoarea precedenta cu 10
        add     eax, ecx        ; adaugam valoarea cifrei actuale
        push    eax
        jmp     next_digit

end_of_number:  
        pop     eax             ; in eax se va afla numarul gasit
        mov     ebx, [ebp + 12] ; i
        mov     dword[ebx], esi ; updatam *i
        jmp     exit_factor

exit_factor:
        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp

        mov     eax, [ebp + 8]
        mov     ebx, [ebp + 12]
        push    ebx
        push    eax
        call    factor          ; apelam functia factor pentru a afla rezultatul precedent
        add     esp, 8
        push    eax             ; pastram resultatul in stiva   

check_if_multiplication:
        mov     ebx, [ebp + 8]
        mov     edi, [ebp + 12]
        mov     esi, dword [edi]
        xor     edx, edx
        mov     dl, byte [ebx + esi]
        cmp     edx, 42                 ; comparam caracterul curent cu '*' 
        jnz     check_if_division
        inc     esi
        mov     dword [edi], esi
        push    edi
        push    ebx
        call    factor   ; apelam functia factor cat sa vedem cu ce este inmultit rezultatul
        add     esp, 8
        pop     ebx
        xor     edx, edx
        mul     ebx     ; inmultim cele doua numere
        push    eax
        jmp     check_if_multiplication ; verificam daca urmatoarea operatie este de asemenea o inmultire

check_if_division:
        mov     ebx, [ebp + 8]
        mov     edi, [ebp + 12]
        mov     esi, dword [edi]
        xor     edx, edx
        mov     dl, byte [ebx + esi]
        cmp     edx, 47         ; comparam caracterul curent cu '/' 
        jnz     exit_term
        inc     esi
        mov     dword [edi], esi
        push    edi
        push    ebx
        call    factor    ; apelam functia factor cat sa vedem la ce este impartit rezultatul
        add     esp, 8
        pop     ebx
        mov     edx, eax
        mov     eax, ebx
        mov     ebx, edx  ; facem swap intre eax si valoarea din stiva, pentru a respecta ordina impartirii 
        cdq
        idiv     ebx      ; facem impartirea cu semn
        push    eax       ; pastram in stiva rezultatul
        jmp     check_if_multiplication ; mergem inapoi la label-ul check_if_multiplication pentru a acoperi toate posibilitatile

exit_term:
        pop     eax       ; returnam rezultatul inmultirilor si impartirilor
        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp
        
        mov     edx, dword [ebp + 8]
        mov     ebx, dword [ebp + 12]
        push    ebx
        push    edx
        call    term    ; apelam functia term pentru ca inmultirile si impartirile au prioritate mai mare
        add     esp, 8
        push    eax     ; pastram pe stiva rezultatul

check_plus:     
        mov     ebx, [ebp + 8]
        mov     edi, [ebp + 12]
        mov     esi, dword [edi]
        xor     edx, edx
        mov     dl, byte [ebx + esi]
        cmp     edx, 43         ; comparam caracterul curent cu '+'
        jnz     check_minus
        inc     esi
        mov     dword [edi], esi
        push    edi
        push    ebx
        call    term    ; apelam functia term cat sa vedem ce se adauga la rezultatul din stiva
        add     esp, 8
        pop     ebx
        add     eax, ebx
        push    eax
        jmp     check_plus

check_minus:
        mov     ebx, [ebp + 8]
        mov     edi, [ebp + 12]
        mov     esi, dword [edi]
        xor     edx, edx
        mov     dl, byte [ebx + esi]
        cmp     edx, 45         ; comparam caracterul curent cu '-'
        jnz     exit_expression
        inc     esi
        mov     dword [edi], esi
        push    edi
        push    ebx
        call    term    ; apelam functia term cat sa vedem ce se scade din rezultatul din stiva
        add     esp, 8
        pop     ebx
        sub     ebx, eax
        push    ebx
        jmp     check_plus  ; sarim inapoi la label-ul check_plus cat sa acoperim si cazul a+b-c+d

exit_expression:
        pop     eax     ; returnam rezultatul din stiva
        leave
        ret
