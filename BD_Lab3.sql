select * from pracownicy;
--1
select nazwisko, stanowisko,
abs(placa+NVL(DOD_FUNKCYJNY,0)+NVL(prowizja,0)) as Pensja,
abs(placa+NVL(DOD_FUNKCYJNY,0)+NVL(prowizja,0)-4251.21) as Odchylenie,
Round(abs(placa+NVL(DOD_FUNKCYJNY,0)+NVL(prowizja,0)-4251.21),1) as "Odchylenie Round",
Trunc(abs(placa+NVL(DOD_FUNKCYJNY,0)+NVL(prowizja,0)-4251.21),1) as "Odchylenie Trunc"
from pracownicy order by pensja desc;
--2
select nazwisko, stanowisko,
placa-(placa*0.18) as "Placa netto",
Round(placa-(placa*0.18),-2) as "Placa zaokraglona",
Round(placa-(placa*0.18),-2) - trunc(placa-(placa*0.18),-2) as "Roznica Round-Trunc"
from pracownicy order by "Placa netto";
--3
select
sqrt(power(12.34,2)+power(77,1/3)) as wynik,
round(sqrt(power(12.34,2)+power(77,1/3))) as ROUND,
trunc(sqrt(power(12.34,2)+power(77,1/3))) as TRUNC,
ceil(sqrt(power(12.34,2)+power(77,1/3))) as CEIL,
floor(sqrt(power(12.34,2)+power(77,1/3))) as FLOOR
from dual;
--4
select Current_date, Sysdate, Current_timestamp, Systimestamp from dual;
--5
select interval '101-11' year(3) to month as "Przedzial A 111 lat 11 m",
interval '25 3:05:36.6' day to second as "Przedzial B 25 dni 3h 5m 36.6s",
TIMESTAMP '101-11-25 03:05:36.6' as Razem
from dual;
--6
select sysdate + interval '123' day(3) as "za 123 dni",
sysdate - interval '321' day(3) as "321 dni temu" from pracownicy;
--7
select Systimestamp,
Systimestamp - interval '7 8:9' day to minute as "PRZESZLOSC",
Systimestamp + interval '19 20:21' day to minute as "PRZYSZLOSC" from dual;
--8
select
timestamp '2017-04-19 9:07:54' - timestamp '2013-11-15 17:28:18' as "Roznica w dniach",
(timestamp '2017-04-19 9:07:54' - timestamp '2013-11-15 17:28:18') year to month as "Roznica w lata-miesiace"
from dual;
--9
select Extract(year FROM sysdate) as ROK,
Extract(month FROM sysdate) as MIESIAC,
Extract(day FROM sysdate) as DZIEN,
Extract(hour FROM Systimestamp) as GODZINA,
Extract(minute FROM Systimestamp) as MINUTA,
ROUND (Extract(second FROM Systimestamp)) as SEKUNDA
from dual;
--10
select Add_months(sysdate,42) as "data +42 miesiace" FROM DUAL;
--11
select Last_day(sysdate) as "Ostatni dzien miesiaca",
To_char(Last_day(sysdate), 'DAY') as "Dzien tygodnia"
from dual;
--12
select Trunc(sysdate, 'year') "do lat", Round(sysdate, 'mm') "do miesiecy" from dual;
--13
select * from studenci;
select nazwisko, imiona, Trunc(Months_between(sysdate,DATA_URODZENIA)/12) WIEK from studenci
where imiona like 'M%' order by WIEK desc, 1;
--14
select Current_timestamp as "aktualny czas", Cast(systimestamp as date) data from dual;
--15
select '987' || '654' lancuch, cast('987' || '654' as number) numer, cast('987' || '654' as number)-123456 roznica from dual;
--16
select To_char(To_char(sysdate, 'CC'),'RN') WIEK from dual;
--17
select To_char(sysdate, 'day , DD month yyyy "Roku"') data from dual;
--18
select To_char(To_date('15-07-1410', 'dd-mm-yyyy'), 'CC "wiek" Q "kwartal" month day') data from dual;
--19
select nazwisko, imiona, data_urodzenia, to_char(to_date(data_urodzenia, 'yy-mm-dd')+1, 'day') as "Dzien tygodnia" from studenci
where to_char(to_date(data_urodzenia, 'yy-mm-dd')+1, 'day') like 'niedziela '
or to_char(to_date(data_urodzenia, 'yy-mm-dd')+1, 'day') like 'sobota%';
--20
select nazwisko, stanowisko, data_zatr, to_char(Trunc(Months_between(sysdate, data_zatr)/12)) || ' lat ' ||
to_char(Trunc(Months_between(sysdate, data_zatr)) - Trunc(Months_between(sysdate, data_zatr)/12)*12) || ' miesiecy' as "Pracuje juz"
from pracownicy where data_zwol is null;
--21
select id_dzialu, nazwisko, Trunc(Months_between(sysdate, data_zatr)/12) as "STAZ" from pracownicy
where (id_dzialu, Trunc(Months_between(sysdate, data_zatr)/12))
in
(select id_dzialu, min(Trunc(Months_between(sysdate, data_zatr)/12)) from pracownicy group by id_dzialu)
order by 1;
--22
select nazwisko, stanowisko, data_zatr, data_zwol, (placa+NVL(DOD_FUNKCYJNY,0)+NVL(prowizja,0)) as pensja from pracownicy
where data_zatr <= '2010-01-01' and (data_zwol > '2010-01-31' or data_zwol is null);
--23
select rok, to_char(to_date(data_urodzenia, 'yy-mm-dd'), 'day') as "Dzien tygodnia", count(*) as liczba from studenci
where mod(extract(day from data_urodzenia), 2)=0 group by rok, to_char(to_date(data_urodzenia, 'yy-mm-dd'), 'day') order by rok, liczba desc;
--24
select kierunek, rok, min(data_urodzenia) najstarszy, max(data_urodzenia) najmlodszy, trunc(months_between(max(data_urodzenia), min(data_urodzenia)), 0) "Liczba miesiecy"
from studenci group by kierunek, rok order by kierunek, rok;
--25
select kierunek, rok, min(data_urodzenia) najstarszy, max(data_urodzenia) najmlodszy,
trunc(months_between(max(data_urodzenia), min(data_urodzenia)), 0) "Liczba miesiecy"
from studenci group by kierunek, rok
having months_between(max(data_urodzenia), min(data_urodzenia))
> (select avg(months_between(max(data_urodzenia), min(data_urodzenia))) from studenci group by kierunek, rok) order by kierunek, rok;