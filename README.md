# Moorov avtomat

V projektu je implementiran Moorov avtomat na primeru kavomata.

Kavomat deluje tako, da moraš najprej vstaviti žeton, za tem si izbereš željen napitek in če ima kavomat dovolj sestavin, ti napitek pripravi. V primeru, da mu
je sestavin zmanjkalo, je kavomat potrebno napolniti s sestavinami, preden lahko ponovno deluje. Kavomat se lahko napolne tudi na vmesnem koraku, naročilo napitka
pa se lahko prekine, če si ga še nismo izbrali. Ker je kavomat majhen ima žal sestavin samo za tri napitke, potem pa ga je potrebno ponovno napolniti oziroma
poklicati serviserja.

## Matematična definicija

Končni avtomat je definiran kot nabor $(\Sigma, Q, q_0, F, \delta)$, kjer so:

- $\Sigma$ končna množica vhodov ali abeceda,
- $Q$ končna množica stanj,
- $q_0 \in Q$ začetno stanje,
- $F \subseteq Q$ množica sprejemnih stanj in
- $\delta : Q \times \Sigma \to Q$ prehodna funkcija.

## Kavomat

Primer kavomata implementiranega v tej projektni nalogi predstavimo z naborom 
$(\{0, 1, 2, 3, 4, 5\}, \{q_0, q_1, q_2, q_3, q_4\}, q_0, \{q_0, q_1, q_2, q_3\}, \delta)$, kjer je $\delta$ podana z naslednjo tabelo:

| $\delta$ | `0`   | `1`   | `2`   | `3`   | `4`   | `5`   |
| -------- | ----- | ----- | ----- | ----- | ----- | ----- |
| $q_0$    | $q_0$ | $q_1$ | $q_1$ | $q_1$ | $q_1$ | $q_0$ |
| $q_1$    | $q_0$ | $q_2$ | $q_2$ | $q_2$ | $q_2$ | $q_1$ |
| $q_2$    | $q_0$ | $q_3$ | $q_3$ | $q_3$ | $q_3$ | $q_2$ |
| $q_3$    | $q_0$ | $q_4$ | $q_4$ | $q_4$ | $q_4$ | $q_3$ |
| $q_4$    | $q_0$ | $q_4$ | $q_4$ | $q_4$ | $q_4$ | $q_4$ |

Znak `0` predstavlja obisk serviserja in kavomat vedno pošlje v začetno stanje, števila `1,2,3,4` so različni napitki, ki jih lahko naročimo, in
vsak pripravljen napitek avtomat pomakne za eno stanje naprej, število `5` pa je preklic naročila, ki nas vrne v isto stanje kot smo bili preden 
smo zadnje naročilo začeli.

## Navodila za uporabo

Program zaženemo preko tekstovnega vmesnka. In sicer v mapi, kjer imamo shranjene vse datoteke, odpremo terminal in vanj napišemo ukaz `dune build`.
To nam ustvari datoteko `tekstovniVmesnik.exe`, ki bo pognala program. Poženemo jo tako, da v terminal napišemo še ukaz `./tekstovniVmesnik.exe`.

## Struktura datotek

V mapi `src` imamo shranjene datoteke v dveh podmapah. V mapi `TekstovniVmesnik` imamo glavno datoteko, ki poganja tekstovni vmesnik, v mapi `Definicije`
pa so shranjene datoteke, ki implementirajo avtomat.

## Viri

Projekt je narejen po zgledu projekta iz vira `https://github.com/matijapretnar/programiranje-1/tree/master/projekt`.
