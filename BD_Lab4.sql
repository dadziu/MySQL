select * from rejestr;
select * from wedkarz;
select * from lowisko;
select * from ryba;
--1a decode (nazwa_kolumny, wartoœæ, zamiennik, wartoœæ2, zamiennik2)
select trunc(dataczas) "Dzien polowu", id_ryby, decode(id_ryby, 1, 'Karp' , 3, 'Leszcz', 9, 'Szczupak', 10, 'Sandacz') gatuek from rejestr order by 1;
--1b
--'id_ryby' nazywa siê tak samo w obu tabelach
select trunc(dataczas) "Dzien polowu", id_ryby, nazwa from rejestr left join ryba using (id_ryby) order by 1;
--2a
select count(*) "Liczba leszczy" from rejestr where id_ryby = 3
and id_lowiska like 'C11'
and extract(year from dataczas)=2015;
--2b
select count(*) "Liczba leszczy"
from rejestr join ryba b using (id_ryby) join lowisko l using (id_lowiska)
where b.nazwa like 'LESZCZ'
and l.miejscowosc like 'Poraj'
and extract(year from dataczas)=2015;
--3
select extract(year from dataczas) rok, min(waga) "Najlzejsza ryba", max(waga) "Najciezsza ryba", count(*) "Liczba ryb",
count(distinct id_ryby) "Liczba gatunkow", count(distinct id_wedkarza) "Liczba wedkarzy", sum(waga), round(avg(dlugosc),2)
from rejestr
where id_ryby is not null
group by extract(year from dataczas)
order by rok;
--4
select count(*) "liczba ryb" from rejestr
where to_char(dataczas, 'month') like '%a%'
and id_ryby is not null
and dataczas between TIMESTAMP '2015-11-14 20:00:00' and (TIMESTAMP '2015-11-14 20:00:00' + interval '370 22:20' day(3) to minute);
--5
select l.id_okregu, l.nazwa, id_lowiska,
count(*) "Liczba polowow", count(id_ryby) "Liczba udanych polowow",
count(distinct id_wedkarza) "Liczba wedkarzy", count(distinct id_ryby) "Liczba zlowionych gatunkow", round(avg(waga),2) "Srednia waga"
from rejestr join lowisko l using(id_lowiska)
where l.ID_OKREGU like 'PZW%'
group by ID_LOWISKA, l.id_okregu, l.nazwa
order by l.id_okregu, "Liczba polowow" desc, 2;
--6
select NVL(r.nazwa, 'Brak polowu') gatunek, id_ryby, count(distinct id_lowiska) "Liczba lowisk",
nvl(trim('0' from min(waga)), ' ') "Najlzejsza ryba",
nvl(trim('0' from max(waga)), ' ') "Najciezsza ryba",
nvl(trim('0' from round(avg(waga),2)), ' ') "Srednia waga"
from rejestr left join ryba r using(id_ryby) group by r.nazwa, id_ryby
order by "Liczba lowisk" desc, 1;
--7
select to_char(dataczas, 'month') miesiac, w.nazwisko,
count(id_ryby) "Liczba ryb (szt.)", count(distinct id_ryby) "Liczba gatunkow", count(distinct id_lowiska) "Liczba lowisk",
count(*)-count(id_ryby) "Liczba nieudanych polowow"
from rejestr join wedkarz w using(id_wedkarza) join lowisko l using(id_lowiska)
where l.ID_OKREGU like 'PZW%'
group by to_char(dataczas, 'month'), w.nazwisko
order by "Liczba ryb (szt.)" desc, 1, 2;
--8
select r.nazwa, max(to_char(dataczas, 'yyyy-mm-dd hh:mm')) "Ostatni polow",
extract(day from sysdate-max(dataczas)) dni
from rejestr join ryba r using(id_ryby)
group by r.nazwa
order by dni, 1;
--9
select r.nazwa, to_char(dataczas, 'yyyy-mm-dd hh:mm') "Ostatni polow",
extract(day from sysdate-(dataczas)) dni, w.nazwisko, l.nazwa "Nazwa lowiska"
from rejestr join ryba r using(id_ryby) join wedkarz w using(id_wedkarza) left join lowisko l using(id_lowiska)
where (r.nazwa, to_char(dataczas, 'yyyy-mm-dd hh:mm'))
in
(select r.nazwa, max(to_char(dataczas, 'yyyy-mm-dd hh:mm'))
from rejestr join ryba r using(id_ryby)
group by r.nazwa)
order by 3, 1;
--10
select r.nazwa, round(avg(waga),2) "Srednia waga", count(*) "Zlowiono sztuk", min(waga) "Min waga", max(waga) "Max waga" from rejestr join ryba r using(id_ryby)
group by r.nazwa having (avg(waga) between 1.2 and 2.2) and count(extract(year from dataczas))>3 and count(id_lowiska)>6 order by 2 desc, 1;
--11
select extract(year from dataczas) rok, r.nazwa, dlugosc, to_char(dataczas, 'yy/mm/dd') Kiedy, w.nazwisko, l.nazwa "Lowisko"
from rejestr join wedkarz w using(id_wedkarza) join ryba r using(id_ryby) join lowisko l using(id_lowiska)
where
(extract(year from dataczas), r.nazwa, dlugosc)
in
(select extract(year from dataczas), r.nazwa, max(dlugosc)
from rejestr join ryba r using(id_ryby)
group by extract(year from dataczas), r.nazwa)
order by 1, 2;
--12
select to_char(r.dataczas, 'yyyy-mm-dd hh:mm') kiedy, r.id_ryby, r.dlugosc, round(ry.sr, 2) srednia
from rejestr r
inner join (select id_ryby, to_char(dataczas, 'yyyy') cz, avg(dlugosc) sr from rejestr
group by id_ryby, to_char(dataczas, 'yyyy')) ry
on r.id_ryby = ry.id_ryby and to_char(dataczas, 'yyyy') like ry.cz
where r.id_ryby is not null and r.dlugosc > ry.sr
order by 1;
--13
select nazwa, rekord_waga, nvl(to_char(waga), 'Brak Polowu') "Najciê¿sza ryba",
nvl(to_char(round(waga / rekord_waga * 100, 2)), ' ') "Procent reordu"
from ryba rr left join rejestr r on rr.id_ryby = r.id_ryby
where waga is null
or ((r.id_ryby, r.waga)
in (select id_ryby, max(waga) from rejestr group by id_ryby) and r.waga * 4 >= rekord_waga)
group by nazwa, rekord_waga, nvl(to_char(waga), 'Brak Polowu'), waga / rekord_waga
order by 4 desc;
--14 ROLLUP
select
decode(grouping(id_wedkarza), 1, 'Razem', id_wedkarza) id_wedkarza,
decode(grouping(extract(year from dataczas)), 1, 'Razem', extract(year from dataczas)) rok,
decode(grouping(id_ryby), 1, ' ', id_ryby) id_ryby, count(*) "liczba polowow" from rejestr
where id_ryby is not null
group by rollup(id_wedkarza, extract(year from dataczas), id_ryby);
--14 CUBE
select decode(grouping(id_wedkarza), 1, ' ', id_wedkarza) id_wedkarza,
decode(grouping(extract(year from dataczas)), 1, ' ', extract(year from dataczas)) rok,
decode(grouping(id_ryby), 1, ' ', id_ryby) id_ryby, count(*) "liczba polowow" from rejestr
where id_ryby is not null
group by cube(id_wedkarza, extract(year from dataczas), id_ryby);
--14 GROUPING SETTINGS
select decode(grouping(id_wedkarza), 1, ' ', id_wedkarza) id_wedkarza,
decode(grouping(extract(year from dataczas)), 1, ' ', extract(year from dataczas)) rok,
decode(grouping(id_ryby), 1, ' ', id_ryby) id_ryby, count(*) "liczba polowow" from rejestr
where id_ryby is not null
group by grouping sets((id_wedkarza, extract(year from dataczas), id_ryby), (id_wedkarza, extract(year from dataczas)), ());
--15
select decode(grouping(id_lowiska), 1, 'Wszystkie lowiska', id_lowiska) lowisko, decode(grouping(id_ryby), 1, 'Razem', id_ryby) gatunek, count(*) liczebnosc, sum(waga) "Laczna waga",
count(distinct id_wedkarza) "Liczba roznych wedkarzy"
from rejestr
where id_ryby is not null
group by grouping sets ((id_lowiska, id_ryby), (id_lowiska), ())
order by 1,5;