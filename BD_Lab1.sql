--1
desc studenci;
--2
select * from studenci;
--3a
select nazwisko, imiona from studenci;
--3b
select distinct kierunek from studenci;
--3c
select nazwisko, imiona, tryb, rok, gr_dziekan, specjalnosc from studenci where kierunek like 'INFORMATYKA' order by rok, nazwisko desc;
--3d
select * from studenci where rok=3 and gr_dziekan=2;
--3e
select * from studenci where specjalnosc is null;
--3f
select nazwisko, imiona, rok from studenci where stopien=1 and rok=2 or rok=3 or rok=4 order by nazwisko;
select nazwisko, imiona, rok from studenci where stopien=1 and rok in (2,3,4) order by nazwisko;
select nazwisko, imiona, rok from studenci where stopien=1 and rok between 2 and 4 order by nazwisko;
--3g
select imiona, nazwisko from studenci where imiona like '%a';
--3h
select imiona, nazwisko from studenci where imiona not like '%a';
--3i
select nazwisko, imiona from studenci where imiona like 'Adam' or imiona like 'Konrad' or imiona like 'Magdalena';
--3j
select * from studenci where nazwisko like 'Kowalsk_' or nazwisko like 'Nowak';
--3k
select distinct imiona from studenci where imiona between 'Ka%' and 'Mi%' order by imiona;
--4
desc pracownicy;
--5a
select nazwisko, placa from pracownicy;
--5b
select nazwisko, placa/20 as dniowka from pracownicy;
select nazwisko, (NVL(dod_funkcyjny,0)+placa+(NVL(prowizja,0)))/20 as dniowka from pracownicy;
--5c
select nazwisko, nr_akt, (NVL(dod_funkcyjny,0)+placa+(NVL(prowizja,0))) as pensja from pracownicy where data_zwol is null order by pensja;
--5d
select nazwisko, nr_akt, (NVL(dod_funkcyjny,0)+placa+(NVL(prowizja,0)))*12 as "roczna pensja" from pracownicy where data_zwol is null and stanowisko not like 'PREZES' and stanowisko not like 'DYREKTOR' order by "roczna pensja" desc;
--5e
select nazwisko||' pracuje w dziale '||id_dzialu||'-tym' as "dzial pracownika" from pracownicy;
--6
desc pojazdy;
--7
select * from pojazdy where (typ like 'SAM.OSOBOWY' or typ like 'S.CIEZ-OSOB.')
and (nr_rejestr like 'SC%1')
and (pojemnosc not between 1500 and 2000)
and (kolor like '%A%' and kolor not like '% %');