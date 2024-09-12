open Definicije
open Avtomat

type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | IzbiraKave
  | PripravaKave
  | Servis

type model = {
  avtomat : t;
  stanje_avtomata : Stanje.t;
  stanje_vmesnika : stanje_vmesnika;
}

type msg =
  | PreberiNiz of string
  | PrekiniNarocilo of stanje_vmesnika
  | ZamenjajVmesnik of stanje_vmesnika
  | VrniVPrvotnoStanje

(*Funkcija, ki posodobi model*)
let update model = function
  | PreberiNiz str -> (
      match preberi_niz model.avtomat model.stanje_avtomata str with
      | None -> { model with stanje_vmesnika = Servis }
      | Some stanje_avtomata ->
          {
            model with
            stanje_avtomata;
            stanje_vmesnika = PripravaKave;
          })
  | PrekiniNarocilo stanje_vmesnika ->
      print_endline "Naročilo je bilo prekinjeno. Vzemite vrnjen kovanec.";
      { model with stanje_vmesnika }
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }
  | VrniVPrvotnoStanje ->
      print_endline "Obisk serviserja je bil uspešen. Kavomat je napolnjen.";
      {
        model with
        stanje_avtomata = zacetno_stanje model.avtomat;
        stanje_vmesnika = SeznamMoznosti;
      }

(*Fukcija, ki nam izpiše, kaj lahko počnemo, ko ga zaženemo*)
let rec izpisi_moznosti () =
  print_endline "Če želite naročiti kavo, vstavite kovanec.";
  print_endline "0) Servis";
  print_endline "1) Vstavi kovanec";
  print_endline "2) Izpis avtomata";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzbiraKave
  | "0" -> VrniVPrvotnoStanje
  | "2" -> ZamenjajVmesnik IzpisAvtomata
  | _ ->
      print_endline "** VNESI 0, 1 ALI 2 **";
      izpisi_moznosti ()

let izpisi_avtomat avtomat =
  let izpisi_stanje stanje =
    let prikaz = Stanje.v_niz stanje in
    let prikaz =
      if stanje = zacetno_stanje avtomat then "-> " ^ prikaz else prikaz
    in
    let prikaz =
      if je_sprejemno_stanje avtomat stanje then prikaz ^ " + " else prikaz
    in
    print_endline prikaz
  in
  List.iter izpisi_stanje (seznam_stanj avtomat)

let rec izbira_kave _model =
  print_endline "Izberite željen napitek:";
  print_endline "0) Servis ";
  print_endline "1) Espreso";
  print_endline "2) Americano";
  print_endline "3) Capuccino";
  print_endline "4) Bela kava";
  print_endline "5) Prekini naročilo";
  match read_line () with
  | "0" -> VrniVPrvotnoStanje
  | "1" -> PreberiNiz "1"
  | "2" -> PreberiNiz "2"
  | "3" -> PreberiNiz "3"
  | "4" -> PreberiNiz "4"
  | "5" -> PrekiniNarocilo SeznamMoznosti
  | _ ->
      print_endline "** VNESI ŠTEVILO OD 0 DO 5 **";
      izbira_kave _model

(*Funkcija, ki določi ali je dovolj sestavin za pripravo kave.*)
let priprava_kave model =
  match je_sprejemno_stanje model.avtomat model.stanje_avtomata with
  | true ->
    print_endline "Napitek je v pripravi. Napitek je pripravljen.";
    ZamenjajVmesnik SeznamMoznosti
  | false -> 
    print_endline "Naročilo je bilo prekinjeno. Kavomatu primankuje sestavin.";
    ZamenjajVmesnik Servis

(*Fukcija, ki se prikaže, ko kavomatu zmanka sestavin.*)
let rec servis _model =
  print_endline "Čakam na serviserja";
  print_endline "0) Serviser je opravil svoje delo.";
  match read_line () with
  | "0" ->
      VrniVPrvotnoStanje
  | _ -> servis _model

(*Funkcija, ki nam prikazuje model in vsakemu stanju vmesnika priredi, kaj naj se zgodi.*)
let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | IzbiraKave -> izbira_kave model
  | PripravaKave ->
      priprava_kave model;
  | Servis -> 
      servis model

let init avtomat =
  {
    avtomat;
    stanje_avtomata = zacetno_stanje avtomat;
    stanje_vmesnika = SeznamMoznosti;
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let _ = loop (init enke_1mod3)
