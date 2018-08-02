select * from studenci;
--1a
select count(*) as "Liczba studentek 3r INF SS" from studenci where imiona like '%a' and kierunek='INFORMATYKA' and tryb='STACJONARNY' and rok=3;
--1b
select count(*) as "Liczba Nowakowskich" from studenci where lower (nazwisko) like 'nowakowsk_' ;
--1c
select count(*) as "Liczba studentów na literê M", count(distinct (imiona)) as "Liczba roznych imion na M" from studenci where imiona not like '%a' and imiona like 'M%';
--1d
select concat(nazwisko, concat (' ', imiona)) "Personalia studenta" from studenci where rok=4 order by nazwisko;
select nazwisko || ' ' || imiona as "Personalia studenta" from studenci where rok=4 order by nazwisko;
--1e
select substr(imiona,1,3) as "3 litery imiona", substr(nazwisko,-3,3),imiona, nazwisko as "3 ostatnie litery nazwiska" from studenci where specjalnosc is null;
--1f
select substr(imiona,1,1)||'.'||substr(nazwisko,1,1)||'.' "INICJALY", imiona, nazwisko, (length (imiona || nazwisko)) as "Liczba liter" from studenci
where (length (imiona || nazwisko)) in (9,11,13);
--1g
select distinct initcap(kierunek) as KIERUNEK from studenci;
select distinct concat(substr(kierunek,1,1), (lower(substr(kierunek,2)))) as KIERUNEK from studenci;
--1h
select ltrim (nazwisko,'Ko') as "nazwisko bez KO", rtrim (imiona,'sz') as "imie bez SZ", nazwisko||' '||imiona as PERSONALIA from studenci where nazwisko like 'Ko%' and imiona like '%sz';
--1i
select nazwisko, length (nazwisko) as "Liczba liter", instr(nazwisko,'a') as "pozycja A w nazwisku" from studenci where rok=2 and ((length (nazwisko)) between 6 and 9) and nazwisko like '%a%' order by "Liczba liter" desc, "pozycja A w nazwisku" desc;
--1j
select nazwisko, replace(nazwisko, 'Ba', 'Start') as "po zmianie", imiona, concat(rtrim(imiona, 'a'), 'End') as "po zmianie im" from studenci where imiona like '%a' and nazwisko like 'Ba%';
--1k
select (lpad('***',3) || nazwisko || rpad('++++',4)) as "Nazwiska" from studenci;
--1l
select rok, count(*) as "liczba studentów" from studenci where stopien=1 and kierunek like 'INFORMATYKA' group by rok order by rok;
--1m
select tryb, kierunek, count(*) as "liczba studentów" from studenci group by tryb, kierunek order by "liczba studentów" desc;
--1n
select rok, stopien, gr_dziekan, count(*) as "liczba_studentek" from studenci where kierunek like 'MATEMATYKA' and imiona like '%a' group by rok, stopien, gr_dziekan order by "liczba_studentek" desc;
--1o
select round(avg(srednia),2) as "srednia", tryb, stopien, kierunek, rok from studenci where srednia is not null group by tryb, stopien, kierunek, rok order by "srednia" desc;
--2 
select * from pracownicy;
--2a
select id_dzialu, round(avg (placa),2) as "srednia placa" from pracownicy group by id_dzialu order by "srednia placa" desc;
--2b
select id_dzialu, count(*) as "liczba pracownikow", min(NVL(dod_funkcyjny,0)+placa+(NVL(prowizja,0))) as "najnizsza pensja", max(NVL(dod_funkcyjny,0)+placa+(NVL(prowizja,0))) as "najwy¿sza pensja" from pracownicy group by id_dzialu order by id_dzialu;
--2c
select id_dzialu, avg (nvl(dod_funkcyjny,0)) as "srednia wartosc dodatku" from pracownicy having count(*) in(4,7) group by id_dzialu;
--2d
select nazwisko, placa, id_dzialu from pracownicy where placa > (select avg(placa) from pracownicy) order by id_dzialu;
--2e
select nazwisko, placa, id_dzialu from pracownicy where placa = (select max(placa) from pracownicy as pp where pp.id_dzialu=id_dzialu);
select nazwisko, placa, id_dzialu from pracownicy where (select id_dzialu from pracownicy group by id_dzialu);
select nazwisko, placa, id_dzialu from (select max(placa), id_dzialu from pracownicy group by id_dzialu) order by id_dzialu;
select max(placa) from pracownicy group by id_dzialu order by id_dzialu;
select e.nazwisko, e.placa, e.id_dzialu from pracownicy e
where placa = (select max(placa) from pracownicy where id_dzialu = e.id_dzialu) order by id_dzialu;