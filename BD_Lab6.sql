--1
--z ANY
select distinct id_wedkarza, nazwisko, imie, data_ur from rejestr
join wedkarz using(id_wedkarza)
join ryba using(id_ryby)
where id_ryby = any (select id_ryby from rejestr where id_ryby=10)
and extract(month from dataczas) between 6 and 9
order by 1;
--COUNT z group by
select id_wedkarza, nazwisko, imie, data_ur from rejestr
join wedkarz using(id_wedkarza)
join ryba using(id_ryby)
where
(extract(month from dataczas) between 6 and 9) and id_ryby=10 --tu sandacz
group by id_wedkarza, nazwisko, imie, data_ur
having count(id_ryby) > 0 --tu ilosc
order by 1;
--2
select id_ryby, nazwa, count(*) "Liczba polowow" from rejestr join ryba using(id_ryby)
where dlugosc >= all(wymiar)
group by id_ryby, nazwa
order by 1;
--3
select id_ryby, nazwa from rejestr join ryba using(id_ryby)
where dlugosc <= any(wymiar)
group by id_ryby, nazwa
order by 1;
--4
select id_okregu, r.nazwa from rejestr join ryba r using(id_ryby) join lowisko using(id_lowiska)
where exists (select id_okregu, id_ryby from rejestr group by id_okregu, id_ryby)
and id_okregu like 'PZW%'
group by id_okregu, r.nazwa
order by 1, 2;
--5
select id_okregu, ry.nazwa from rejestr join lowisko using(id_lowiska) join ryba ry using(id_ryby)
where id_okregu like 'PZW%'
group by ry.nazwa, id_okregu
having count(id_ryby)>2
order by 1, 2;
--6
--z ALL/ANY
select distinct id_wedkarza, nazwisko, imie, data_ur
from wedkarz join rejestr using(id_wedkarza)
where id_wedkarza != all(select distinct id_wedkarza from rejestr
where id_ryby is not null
and (id_wedkarza, id_lowiska) != any(select id_wedkarza, id_lowiska from rejestr where id_ryby is null));

--z MINUS
select * from
(select id_wedkarza from rejestr --wszyscy wedkarze
group by id_wedkarza

minus

select id_wedkarza from --3

(select id_wedkarza, id_lowiska from rejestr --wszystkie lowiska na ktorych lowili
group by id_wedkarza, id_lowiska
minus
select id_wedkarza, id_lowiska from rejestr where id_ryby is null --wszystkie lowiska na ktorych nie zlowili ryby
group by id_wedkarza, id_lowiska)

group by id_wedkarza) --3
join wedkarz using(id_wedkarza)

order by 1;
--7
select id_lowiska, id_okregu, nazwa, typ, miejscowosc, powierzchnia from

(select id_lowiska from rejestr
where id_ryby = 9
group by id_lowiska, extract(year from dataczas)
having sum(nvl(waga, 0)) >= all(select 4 from rejestr) and sum(nvl(waga, 0)) <= all(select 10 from rejestr)
order by id_lowiska, extract(year from dataczas))

join lowisko using(id_lowiska);
--9
select nazwa, count(*) sztuk, listagg(nazwisko, ' ') within group(order by nazwisko) lowcy from rejestr join wedkarz using(id_wedkarza) join ryba using(id_ryby) group by nazwa
order by 1;
--10
select nazwa, count(*), listagg(nazwisko, ' ') within group(order by nazwisko)
from (select nazwa, nazwisko from rejestr join wedkarz using(id_wedkarza) join ryba using(id_ryby)) group by nazwa;
--11
select nazwa, sztuk, lowcy from

(select nazwa, listagg(wedkarzMaRyb, ' ') within group(order by wedkarzMaRyb) lowcy
from
(select nazwa, nazwisko || '(' || count(*) || ')' wedkarzMaRyb from rejestr join wedkarz using(id_wedkarza) join ryba using(id_ryby)
group by nazwa, nazwisko)
group by nazwa)

join

(select nazwa, count(*) sztuk from rejestr join wedkarz using(id_wedkarza) join ryba using(id_ryby) group by nazwa)
using (nazwa);