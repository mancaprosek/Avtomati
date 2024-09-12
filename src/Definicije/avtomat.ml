type stanje = Stanje.t

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * stanje) list;
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [];
    zacetno_stanje;
    sprejemna_stanja = [];
    prehodi = [];
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  }

let dodaj_prehod stanje1 znak stanje2 avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2) :: avtomat.prehodi }

let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None
  | Some (_, _, stanje2) -> Some stanje2

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi

let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja

let enke_1mod3 =
  let q0 = Stanje.iz_niza "q0"
  and q1 = Stanje.iz_niza "q1"
  and q2 = Stanje.iz_niza "q2"
  and q3 = Stanje.iz_niza "q3"
  and q4 = Stanje.iz_niza "q4" in
  prazen_avtomat q0 |> dodaj_sprejemno_stanje q0 |> dodaj_sprejemno_stanje q1
  |> dodaj_sprejemno_stanje q2 |> dodaj_sprejemno_stanje q3 |> dodaj_nesprejemno_stanje q4
  |> dodaj_prehod q0 '1' q1 |> dodaj_prehod q1 '1' q2 |> dodaj_prehod q2 '1' q3 |> dodaj_prehod q3 '1' q4 |> dodaj_prehod q4 '1' q4
  |> dodaj_prehod q0 '2' q1 |> dodaj_prehod q1 '2' q2 |> dodaj_prehod q2 '2' q3 |> dodaj_prehod q3 '2' q4 |> dodaj_prehod q4 '2' q4
  |> dodaj_prehod q0 '3' q1 |> dodaj_prehod q1 '3' q2 |> dodaj_prehod q2 '3' q3 |> dodaj_prehod q3 '3' q4 |> dodaj_prehod q4 '3' q4
  |> dodaj_prehod q0 '4' q1 |> dodaj_prehod q1 '4' q2 |> dodaj_prehod q2 '4' q3 |> dodaj_prehod q3 '4' q4 |> dodaj_prehod q4 '4' q4
  |> dodaj_prehod q0 '5' q0 |> dodaj_prehod q1 '5' q1 |> dodaj_prehod q2 '5' q2 |> dodaj_prehod q3 '5' q3 |> dodaj_prehod q4 '5' q4
  |> dodaj_prehod q4 '0' q0
  
let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with
    |None -> None
    |Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q)
