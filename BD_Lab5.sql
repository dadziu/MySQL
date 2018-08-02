select * from rejestr;
select * from wedkarz;
select * from lowisko;
select * from ryba;
select * from licencja;
select * from oplata;
--1
--UNION
select dataczas, dlugosc, id_ryby, 'Powyzej sredniej' komentarz from rejestr where id_ryby=9 and dlugosc > 60
union
select dataczas, dlugosc, id_ryby, 'Rowna sredniej' from rejestr where id_ryby=9 and dlugosc = 60
union
select dataczas, dlugosc, id_ryby, 'Ponizej sredniej' from rejestr where id_ryby=9 and dlugosc < 60;
--CASE
select dataczas, dlugosc, id_ryby,
case --poczatek case
when (dlugosc>60) then 'Powyzej sredniej'
when (dlugosc=60) then 'Rowna sredniej'
when (dlugosc<60) then 'Ponizej sredniej'
else 'test'
end komentarz--koniec case
from rejestr where id_ryby=9;
--2
select id_ryby, nazwa from ryba
minus
select id_ryby, nazwa from rejestr join ryba r using(id_ryby);
--3
select id_ryby, decode(id_ryby, 3, 'LESZCZ', 9, 'SZCZUPAK', 10, 'SANDACZ') nazwa from rejestr where id_lowiska like 'C11' and id_ryby is not null
INTERSECT
select id_ryby, decode(id_ryby, 3, 'LESZCZ', 9, 'SZCZUPAK', 10, 'SANDACZ') nazwa from rejestr where id_lowiska like 'C40';
--4
select rok, id_wedkarza, id_okregu
from licencja join lowisko l using (id_okregu) where id_okregu like 'PZW%'
minus
select extract(year from dataczas), id_wedkarza, id_okregu
from rejestr join lowisko l using(id_lowiska)
order by 1, 2;
--5 COUNT LIKE 'tekst'
select id_wedkarza, nazwisko, imie from rejestr join lowisko l using(id_lowiska) join wedkarz w using(id_wedkarza)
where id_okregu not like 'PZW%'
intersect
select id_wedkarza, nazwisko, imie from rejestr join lowisko l using(id_lowiska) join wedkarz w using(id_wedkarza)
where id_okregu like 'PZW Czestochowa' --like 'tekst'
group by id_wedkarza, nazwisko, imie having count(id_okregu) > 1 --count
intersect
select id_wedkarza, nazwisko, imie from rejestr join lowisko l using(id_lowiska) join wedkarz w using(id_wedkarza)
where extract(year from dataczas)=2014 and id_ryby is null
order by 1;
--6
select extract(year from dataczas) rok, round(avg(nvl(waga, 0)), 2) "Waga w Kg", 'srednia z lacznych wag' komentarz
from rejestr group by extract(year from dataczas)
union
select rok, max(waga_suma), 'maksymalna laczna waga' from (select extract(year from dataczas) rok, sum(waga) waga_suma from rejestr
group by id_wedkarza, extract(year from dataczas))
group by rok
order by 1;
--7
select * from --4;
(select extract(year from dataczas) rok, sum(nvl(waga, 0))  "Waga w Kg", nazwisko, imie from wedkarz --3
  join rejestr r using (id_wedkarza) --3
group by extract(year from dataczas), nazwisko, imie) --group by rok, naz, im + waga --3

join --intersect [using (rok, waga)] na rok i wage || bierze tylko wiersze tylko te ktore sa w dolnym --4

-- rok, maksymalne i minimalne wagi:
(select rok, max(waga_suma)  "Waga w Kg", 'Najwieksza laczna waga' komentarz from --2
(select extract(year from dataczas) rok, sum(waga) waga_suma from rejestr --1
group by id_wedkarza, extract(year from dataczas)) --1
group by rok --2
union all
select rok, min(waga_suma)  "Waga w Kg", 'Najmniejsza laczna waga' from --2
(select extract(year from dataczas) rok, nvl(sum(waga), 0) waga_suma from rejestr--1
group by id_wedkarza, extract(year from dataczas)) --1
group by rok) --2

using (rok,  "Waga w Kg") --3

order by 1, 2; --4

--8
select rok, id_okregu, sum(oplata_roczna) "Lacznie zl.", count(*) "Liczba licencji", 'Suma oplat z licencji rocznych' komentarz
from licencja join oplata using(rok, id_okregu) where (to_date(do_dnia, 'dd-mm')-to_date(od_dnia, 'dd-mm'))=364
group by rok, id_okregu
union
select rok, id_okregu, sum(oplata_dzienna*(to_date(do_dnia, 'dd-mm')-to_date(od_dnia, 'dd-mm'))), sum((to_date(do_dnia, 'dd-mm')-to_date(od_dnia, 'dd-mm'))), 'Suma oplat z licencji okresowych'
from licencja join oplata using(rok, id_okregu) where (to_date(do_dnia, 'dd-mm')-to_date(od_dnia, 'dd-mm'))<364
and (to_date(do_dnia, 'dd-mm')-to_date(od_dnia, 'dd-mm'))>0
group by rok, id_okregu
order by 1, 2;
--9
select id_wedkarza, nazwisko,
decode("PZW Czestochowa", null, 'NIE', 'TAK') "PZW Czestochowa", nvl("L. polowow Cz", 0) "L. polowow Cz",
decode("PZW Katowice", null, 'NIE', 'TAK') "PZW Katowice", nvl("L. polowow K", 0) "L. polowow K",
decode("PZW Opole", null, 'NIE', 'TAK') "PZW Opole", nvl("L. polowow O", 0) "L. polowow O",
decode("Lowiska poza PZW", null, 'NIE', 'TAK') "Lowiska poza PZW", nvl("L. polowow", 0) "L. polowow"
from
--Czestochowa
(select id_wedkarza, nazwisko,
case
when (count(*)>0) then 'TAK'
end "PZW Czestochowa",
count(*) "L. polowow Cz"
from rejestr join lowisko using(id_lowiska) join wedkarz using(id_wedkarza)
where id_okregu like 'PZW Czestochowa'
group by id_wedkarza, nazwisko)

full join
--Katowice
(select id_wedkarza, nazwisko,
case
when (count(*)>0) then 'TAK'
end "PZW Katowice",
count(*) "L. polowow K"
from rejestr join lowisko using(id_lowiska) join wedkarz using(id_wedkarza)
where id_okregu like 'PZW Katowice'
group by id_wedkarza, nazwisko)
using(id_wedkarza, nazwisko)

full join
--Opole
(select id_wedkarza, nazwisko,
case
when (count(*)>0) then 'TAK'
end "PZW Opole",
count(*) "L. polowow O"
from rejestr join lowisko using(id_lowiska) join wedkarz using(id_wedkarza)
where id_okregu like 'PZW Opole'
group by id_wedkarza, nazwisko)
using(id_wedkarza, nazwisko)

full join
--Reszta
(select id_wedkarza, nazwisko,
case
when (count(*)>0) then 'TAK'
end "Lowiska poza PZW",
count(*) "L. polowow"
from rejestr join lowisko using(id_lowiska) join wedkarz using(id_wedkarza)
where id_okregu not like 'PZW%'
group by id_wedkarza, nazwisko)
using(id_wedkarza, nazwisko)

order by 1;
--10
select id_ryby, nazwa,
case
when okregi=1 then '1 okregu'
when okregi=2 then '2 okregow'
when okregi=3 then '3 okregow'
when okregi>3 then 'wielu okregow'
else 'niezlowiona'
end "Zlowiona w wodach"
from ryba

left join

(select id_ryby, count(distinct id_okregu) okregi from rejestr join lowisko using (id_lowiska)
where id_okregu like 'PZW %'
group by id_ryby)

using (id_ryby)
order by 1;
--11 CROSS JOIN
select r1.nazwa "Gatunek 1", r1.wymiar "Wymiar 1", r2.nazwa "Gatunek 2", r2.wymiar "Wymiar 2", abs(r1.wymiar-r2.wymiar) roznica
from ryba r1
cross join ryba r2
where r1.wymiar is not null
and r1.nazwa<>r2.nazwa
and ((r1.wymiar-r2.wymiar)<=10 and (r2.wymiar-r1.wymiar)<=10)
and r1.id_ryby < r2.id_ryby
order by r1.id_ryby, r2.id_ryby;
--12
select k.nazwisko "Kierownik", p.nazwisko "Pracownik", p.id_dzialu, d.nazwa from pracownicy k
right join pracownicy p on k.nr_akt = p.kierownik
left join dzialy d on (p.id_dzialu = d.id_dzialu)
order by 1;