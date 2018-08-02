drop table zawodnicy cascade CONSTRAINTS;--usuwanie tabeli
--1
create table Zawodnicy
(
id_zawodnika number(4) primary key,
nazwisko varchar(10) not null,
imie varchar(15) not null,
data_ur date check(data_ur > to_date('01-01-1950', 'DD-MM-YYYY')),
wzrost number(3) check(wzrost between 120 and 200),
waga number(3,1) check(waga between 20 and 120),
pozycja varchar(20) check(pozycja in ('bramkarz', 'obronca', 'pomocnik', 'napastnik')),
klub varchar(30) default('wolny zawodnik'),
licz_minut number(5) default(0),
placa number(4)
);
--2
insert into Zawodnicy values(1001, 'Nowak', 'Piotr', to_date('10.01.1990', 'DD-MM-YYYY'), 192, 81.5, 'bramkarz', 'Warta Czestochowa', 360, 4000);
insert into Zawodnicy values(1002, 'Kowalski', 'Adam', to_date('15.04.1992', 'DD-MM-YYYY'), 194, 83, 'bramkarz', 'Odra Wroclaw', 270, 3500);
insert into Zawodnicy values(1003, 'Polak', 'Dariusz', to_date('11.06.1998', 'DD-MM-YYYY'), 189, 79.5, 'bramkarz', 'Wisla Warszawa', 450, 5000);
insert into Zawodnicy values(1004, 'Malinowski', 'Adrian', to_date('21.11.1987', 'DD-MM-YYYY'), 190, 85, 'obronca', 'Warta Czestochowa', 300, 3000);
insert into Zawodnicy values(1005, 'Czech', 'Piotr', to_date('04.12.1989', 'DD-MM-YYYY'), 187, 83, 'obronca', 'Odra Wroclaw', 200, 2600);
insert into Zawodnicy values(1006, 'Podolski', 'Krystian', to_date('26.02.1997', 'DD-MM-YYYY'), 186, 89, 'obronca', 'Wisla Warszawa', 350, 3500);
insert into Zawodnicy (id_zawodnika, nazwisko, imie, data_ur, wzrost, waga, pozycja) values (1007, 'Oleksy', 'Robert', to_date('12.08.1996', 'DD-MM-YYYY'), 185, 85, 'obronca');
insert into Zawodnicy values(1008, 'Grzyb', 'Krzysztof', to_date('17.09.1995', 'DD-MM-YYYY'), 173, 75, 'pomocnik', 'Warta Czestochowa', 400, 3200);
insert into Zawodnicy values(1009, 'Kwasek', 'Artur', to_date('30.10.1991', 'DD-MM-YYYY'), 180, 75, 'pomocnik', 'Odra Wroclaw', 370, 3300);
insert into Zawodnicy values(1010, 'Kukla', 'Kamil', to_date('01.02.1993', 'DD-MM-YYYY'), 179, 75, 'pomocnik', 'Wisla Warszawa', 250, 3000);
insert into Zawodnicy (id_zawodnika, nazwisko, imie, data_ur, wzrost, waga, pozycja) values (1011, 'Drozd', 'Adam', to_date('19.03.1985', 'DD-MM-YYYY'), 182, 77, 'pomocnik');
insert into Zawodnicy values(1012, 'Jankowski', 'Marek', to_date('23.09.1999', 'DD-MM-YYYY'), 185, 80, 'napastnik', 'Warta Czestochowa', 60, 2000);
insert into Zawodnicy values(1013, 'Knysak', 'Fabian', to_date('10.10.1994', 'DD-MM-YYYY'), 175, 73, 'napastnik', 'Odra Wroclaw', 250, 4000);
insert into Zawodnicy values(1014, 'Tyrek', 'Tomasz', to_date('31.01.1998', 'DD-MM-YYYY'), 179, 74, 'napastnik', 'Wisla Warszawa', 200, 6000);
insert into Zawodnicy (id_zawodnika, nazwisko, imie, data_ur, wzrost, waga, pozycja) values (1015, 'Zachara', 'Mateusz', to_date('09.09.2000', 'DD-MM-YYYY'), 181, 73, 'napastnik');

insert into Zawodnicy values(1016, 'Biadrych', 'Olgierd', to_date('6.10.1983', 'DD-MM-YYYY'), 183, 76, 'obronca', 'Warta Czestochowa', 120, 3000);
insert into Zawodnicy values(1017, 'Knysia', 'Bartosz', to_date('12.12.1992', 'DD-MM-YYYY'), 174, 73, 'pomocnik', 'Odra Wroclaw', 250, 4000);
insert into Zawodnicy values(1018, 'Kobiech', 'Janusz', to_date('22.03.2001', 'DD-MM-YYYY'), 172, 70, 'napastnik', 'Wisla Warszawa', 120, 2500);
insert into Zawodnicy (id_zawodnika, nazwisko, imie, data_ur, wzrost, waga, pozycja) values (1019, 'Parkan', 'Alan', to_date('13.09.1997', 'DD-MM-YYYY'), 171, 69, 'napastnik');
insert into Zawodnicy values(1020, 'Maniak', 'Zbigniew', to_date('16.02.1995', 'DD-MM-YYYY'), 173, 72, 'bramkarz', 'Warta Czestochowa', 90, 2000);
--3
delete from Zawodnicy where (months_between(sysdate, data_ur)/12) < 21;
delete from Zawodnicy;
drop table zawodnicy;
--4
insert into Zawodnicy values(1016, 'Wojciechowski', 'Olgierd', to_date('6.10.1993', 'DD-MM-YYYY'), 183, 76, 'obronca', 'Warta Czestochowa', 320, 3000);
insert into Zawodnicy values(1017, 'Knysia', 'Bartosz', to_date('12.12.1949', 'DD-MM-YYYY'), 174, 73, 'pomocnik', 'Odra Wroclaw', 250, 4000);
insert into Zawodnicy values(1018, 'Kobiech', 'Janusz', to_date('22.03.2001', 'DD-MM-YYYY'), 203, 133, 'napastnik', 'Wisla Warszawa', 120, 2500);
insert into Zawodnicy (id_zawodnika, nazwisko, imie, data_ur, wzrost, waga, pozycja) values (1019, 'Parkan', 'Alan', to_date('13.09.1997', 'DD-MM-YYYY'), 171, 69, 'œrodkowy napastnik');
insert into Zawodnicy values(10000, 'Maniak', 'Zbigniew', to_date('16.02.1995', 'DD-MM-YYYY'), 173, 72, 'bramkarz', 'Warta Czestochowa', 90, 2000);
--5
update Zawodnicy set licz_minut=(licz_minut+90) where klub like 'Warta Czestochowa' or klub like 'Odra Wroclaw';
--6
update Zawodnicy set placa=(placa*(1/5)+placa) where licz_minut=(select max(licz_minut) from Zawodnicy);
--7
update Zawodnicy set placa=1000, --1
klub= --1

(select * from ( --2

(select klub from Zawodnicy where klub not like 'wolny zawodnik' group by klub  --3
having count(*) =  --3
(select min(z.liczba) from (select count(*) liczba from Zawodnicy where klub not like 'wolny zawodnik' group by klub) z)) --3

) where rownum = 1) --2

where klub like 'wolny zawodnik'; --1
--8
update Zawodnicy set placa = placa+2000,
klub = 'Warta Czestochowa'
where data_ur = (select max(data_ur) from Zawodnicy where klub like 'Odra Wroclaw');
--9
update Zawodnicy set licz_minut=
case klub
when 'Warta Czestochowa' then licz_minut+((length(imie)+length(nazwisko))*10)
when 'Odra Wroclaw' then licz_minut+(length(nazwisko)*20)
when 'Wisla Warszawa' then licz_minut+(length(imie)*20)
end
where licz_minut >= 1;
--10
update Zawodnicy set
klub = 'wolny zawodnik',
placa = null

where  -- kiedy najstarszy
data_ur=(select min(data_ur) from Zawodnicy) -- kiedy chodzi o najstarszego zawodnika
and
(select licz_minut from Zawodnicy
where data_ur=(select min(data_ur) from Zawodnicy)
and data_ur=(select min(data_ur) from Zawodnicy)) not in -- l. minut kiedy chodzi o najstarszego zawodnika

(select max(licz_minut) from Zawodnicy group by klub); -- kiedy l. minut najstarszego jest inna ni¿ max w klubie
------------------------------------
UPDATE zawodnicy
SET klub = 'wolny zawodnik', placa = NULL
WHERE data_ur IN (SELECT MIN(data_ur) FROM zawodnicy) AND
  (klub, licz_minut) NOT IN (SELECT klub, max(licz_minut) FROM zawodnicy GROUP BY klub);
--11
update Zawodnicy set
placa = case
when licz_minut < (select (avg(licz_minut))/2 from zawodnicy) then placa*0.8
when licz_minut < (select (avg(licz_minut))*0.8 from zawodnicy) then placa*0.9
when licz_minut > (select (avg(licz_minut))*1.5 from zawodnicy) then placa*1.2
when licz_minut > (select (avg(licz_minut))*1.2 from zawodnicy) then placa*1.1
else placa
end;