# Tema 3 - _Infernul lui Biju_
_MARIA TEODOR_
323CD

# Tasks
* **Task 1** - Am folosit 2 bucle recursive, una pentru label-ul parse, iar cealalta
 inauntrul acesteia, avand scopul de a gasi nodul cu valoarea minima. Dupa ce 
 minimul era gasit, daca nu era ultimul nod cu valoarea maxima, campul next era 
populat cu valoarea dummy 1, pentru a nu fi gasit din  nou de get_min. Incepand 
cu al doilea element minim, minimul precedent primeste ca next adresa nodului 
minim curent. Ultimul element va avea next null.
* **Task 2** -
    * **Cmmmc** - La inceput am pastrat in stiva o copie suplimentara a lui b. 
Am cautat divizorii lui a, iar in cazul in care gaseam unul, verificam daca il 
divide si pe b. In acest caz, imparteam valorile de pe stiva cu acesta si cautam
in continuare divizori ai valorii noi a lui a. La final, am inmultit valoarea
initiala a lui b, pastrata in stiva, cu valoarea dupa impartiri a lui a, obtinand
cmmmc.
    * **Parantheses** - Am parcurs string-ul, pastrand pe stiva nr de paranteze 
    deschide, dar nu inchise. cu fiecare caracter, updatam valoarea din stiva.
    Daca aceasta valoarea ajunge la 0 si se citeste o paranteza inchisa, se 
    returneaza 0. La final se verifica ca valoarea din stiva sa fie 0, pentru ca
    toate parantezele deschise sa fi fost inchise. 
* **Task 3** - Am apelat functia strtok repetat pentru a imparti in cuvinte, 
iar apoi am scris functia compare, care apeleaza strlen si strcmp pentru a compara
2 siruri de caractere, folosindu-o dupa pentru a chema qsort.
* **Task 4** - functia factor va verifica daca elementul curect este o paranteza
deschisa, caz in care apeleaza functia expression pentru a afla rezultatul tuturor 
operatiilor dintre paranteze, returnandu-l si incrementand din nou pozitia pentru 
a trece si de paranteza inchisa. In cazul in care gaseste un numar, ea returneaza 
valoarea acestuia, parcurgand toate cifrele. In term, se apeleaza mai intai factor,
pentru a gasi primul factor al inmultirii/impartirii. Apoi, se intra intr-o bucla
recursiva care rezolva inmultiri si impartiri consecutive, caci acestea au cea mai 
mare prioritate. Pentru a afla urmatorul factor, se apeleaza tot functia factor. In 
expression, se apeleaza mai intai term, pentru a se rezolva inmultirile sau 
impartirile, dupa care se intra intr-o bucla care rezolva toate adunarle si 
scaderile consecutive. Pentru a afla termenul al doilea, se apeleaza functia term, 
pentru a acoperi cazul in care acesta este o inmultire sau impartire. 
* **Task-uri bonus**
    * **64bit** - Principalul lucru pe care l-am luat in calcul a fost faptul ca
    parametrii unei functii se retin in registre speciale. Le-am pastrat pe acestea 
    intacte, si am lucrat cu cele ramase. Am rezolvat problema printr-o bucla care
    avea drept contor numarul de elemente adaugate pana acum in v, pastrand in stiva 
    nr de elemente adaugate din fiecare dintre v1 si v2.
    * **AT&T** - Am respectat sintaxa AT&T. Mai intai am adaugat vectorii, apoi 
    am apelat de 3 ori macro-ul in care scalam pozitia pentru n elemente si updatam 
    valoarea de la pozitia scalata din v scazand valoarea mentionata din ea.
    * **CPUID** - Pentru manufactorer id string am pus in eax 0 si am luat 
    rezultatul din ebx, edx si ecx. Pentru vmx, rdrand si avx am verificat bitii
    5, 30 si 28 din ecx dupa ce am apelat cpuid cu eax avand valoarea 1. Punand 
    in eax 80000006h, am obtinut in ecx informatii despre cache. Bitii [7:0] din 
    ecx sunt l2 cache line size in bytes, pe cand [31:16] reprezinta cache size 
    in KB.
