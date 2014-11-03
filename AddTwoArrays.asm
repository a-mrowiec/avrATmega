/*
* Add_two_arrays.asm
*
* Authors: Adrian Mrowiec
*/
#include "m32def.inc"
; Rozmiar stały
.EQU LEN = 0x01
; Segment danych
.DSEG
; Dwie tablice o rozmiarze stałym
tab1: .BYTE LEN
tab2: .BYTE LEN
; Segment kodu
.CSEG


; Inicjalizacja stosu
LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16,LOW(RAMEND)
OUT SPL,R16


; Rejestr X wykorzystujemy jako wskaznik pierwszej tablicy
LDI XL, LOW(tab1)
LDI XH, HIGH(tab1)
; Rejestr Y wykorzystujemy jako wskaznik do drugiej tablicy
LDI YL, LOW(tab2)
LDI YH, HIGH(tab2)
; Wpisujemy wielkosc tablic do rejestru Z
LDI ZL, LOW(LEN)
LDI ZH, HIGH(LEN)

CALL DODAJ

RJMP END_PROGRAM

DODAJ:

; Zapisujemy wartości rejestrów na stosie żeby je potem odzyskac
PUSH R0
PUSH R14
PUSH R16
PUSH R17
PUSH R18

; Wyczyszczenuie wszystkich flag
CLC
; Wypełniamy rejestr 18 jedynkami - aby potem odzyskać wartość flagi carry
LDI R18,0xff
; Po dodaniu samych jedynek do tego rejestru który przetrzymuje wartość flagi carry
; flaga carry zostaje ustawiona na poprzednią wartość
LDI R14,0

; Poczatek petli
LOOP:
; Sprawdzamy czy pierwsa połówka Z jest różna od 0
CPI ZL,0
; Jeśli jest różna to napewno musimy jeszcze kontynuować
BRNE AFTER_IF
; Jeśli jest równa 0 to sprawdzamy drugą połówkę
CPI ZH,0
BREQ END_FUNC
AFTER_IF:
; Do rejestru 16 wpisujemy wartosc wskazywana przez X i przesuwamy i na kolejny bajt
LD R16,X+
; Do rejestru 17 wpisujemy wartos wskazywana przez Y
LD R17,Y
; Dodanie wartości rejestrow:
; czyszczenie flagi carry
CLC
; odzyskanie poprzedniej wartosci flagi carry
ADD R14, R18
; Dodajemy rejestry
ADC R17, R16
; zapisanie wartosci carry
CLR R14
ADC R14, R0
; Wpisanie wartosci dodanej do komorki wskazywanej przez Y i przesuniecie wskaznika Y na kolejny bajt
ST Y+,R17
; Z--
CLC
SBCI ZL, 1
SBCI ZH, 0
CLZ
; Koniec petli
RJMP LOOP
; koniec
END_FUNC:

; Odzyskujemy wartosci rejestrow
POP R0
POP R14
POP R16
POP R17
POP R18

RET

END_PROGRAM:

RJMP END_PROGRAM
