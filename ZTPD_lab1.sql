--BEGIN
--    EXECUTE IMMEDIATE 'DROP TABLE SAMOCHODY CASCADE CONSTRAINTS';
--    EXECUTE IMMEDIATE 'DROP TABLE WLASCICIELE CASCADE CONSTRAINTS';
--    -- Add more tables as needed
--END;
--/
--BEGIN
--    EXECUTE IMMEDIATE 'DROP TYPE SAMOCHOD FORCE';
--    EXECUTE IMMEDIATE 'DROP TYPE WLASCICIEL FORCE';
--    -- Add more types as needed
--END;
--/

--Zad1

CREATE OR REPLACE TYPE Samochod AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2)
);
/
desc samochod;

CREATE TABLE Samochody OF Samochod;

INSERT INTO Samochody VALUES (
    NEW Samochod('FIAT', 'RAVA', 60000, DATE'1999-11-30', 25000)
);
INSERT INTO Samochody VALUES (
    NEW Samochod('FORD', 'MONDEO', 80000, DATE'1997-05-10', 45000)
);
INSERT INTO Samochody VALUES (
    NEW Samochod('MAZDA', '323', 12000, DATE'2000-09-22', 52000)
);


select * from samochody;
/

--Zad2
CREATE OR REPLACE TYPE wlasciciel AS OBJECT (
    IMIE VARCHAR2(100),
    NAZWISKO VARCHAR2(100),
    AUTO SAMOCHOD
);
/
desc wlasciciel;

CREATE TABLE wlasciciele OF wlasciciel;

desc wlasciciele;

INSERT INTO wlasciciele VALUES (
    NEW wlasciciel('JAN ', 'KOWALSKI', NEW SAMOCHOD('FIAT', 'SEICENTO', 30000, TO_DATE('0010-12-02', 'YYYY-MM-DD'), 19500))
);
INSERT INTO wlasciciele VALUES (
    NEW wlasciciel('ADAM ', 'NOWAK', NEW SAMOCHOD('OPEL', 'ASTRA', 34000, TO_DATE('0009-06-01', 'YYYY-MM-DD'), 33700))
);

select * from wlasciciele;

SELECT 
    w.*,
    w.auto.marka
FROM wlasciciele w;

--Zad3
DROP TABLE Samochody;
DROP TYPE Samochod force;

CREATE OR REPLACE TYPE Samochod AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER 
);
/

CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        v_wartosc NUMBER;                    
        v_rok_aktualny NUMBER := EXTRACT(YEAR FROM SYSDATE);
        v_rok_produkcji NUMBER := EXTRACT(YEAR FROM DATA_PRODUKCJI); 
        v_wiek NUMBER := v_rok_aktualny - v_rok_produkcji;  
    BEGIN
        v_wartosc := CENA * POWER(0.9, v_wiek);   
        RETURN v_wartosc;                          
    END wartosc;
END;
/
CREATE TABLE Samochody OF Samochod;
INSERT INTO Samochody VALUES (
    NEW Samochod('FIAT', 'RAVA', 60000, DATE'1999-11-30', 25000)
);
INSERT INTO Samochody VALUES (
    NEW Samochod('FORD', 'MONDEO', 80000, DATE'1997-05-10', 45000)
);
INSERT INTO Samochody VALUES (
    NEW Samochod('MAZDA', '323', 12000, DATE'2000-09-22', 52000)
);

select s.marka, s.model, s.kilometry, s.data_produkcji,s.cena, s.wartosc() as aktualna_cena
from samochody s;

--zad4
DROP TABLE Samochody;
DROP TYPE Samochod force;

CREATE OR REPLACE TYPE Samochod AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);
/

ALTER TYPE Samochod ADD MAP 
MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;
/
CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        v_wartosc NUMBER;                    
        v_rok_aktualny NUMBER := EXTRACT(YEAR FROM SYSDATE);
        v_rok_produkcji NUMBER := EXTRACT(YEAR FROM DATA_PRODUKCJI); 
        v_wiek NUMBER := v_rok_aktualny - v_rok_produkcji;  
    BEGIN
        v_wartosc := CENA * POWER(0.9, v_wiek);   
        RETURN v_wartosc;                          
    END wartosc;
    
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN ROUND(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI) + (KILOMETRY / 10000), 2);
    END odwzoruj;
END;
/
SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--zad5
DROP TYPE wlasciciel FORCE;
DROP TABLE WLASCICIELE;
/
CREATE OR REPLACE TYPE WLASCICIEL AS OBJECT (
    IMIE VARCHAR2(100),
    NAZWISKO VARCHAR2(100)
);
/
CREATE TABLE WLASCICIELE OF WLASCICIEL;
/

INSERT INTO WLASCICIELE VALUES (NEW WLASCICIEL('Jan', 'Kowalski'));
/

DROP TYPE samochod FORCE;

CREATE OR REPLACE TYPE samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2),
    wlasciciel_atr REF WLASCICIEL,
    MEMBER FUNCTION wartosc RETURN NUMBER
);
/
ALTER TYPE Samochod ADD MAP 
MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;
/
CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        v_wartosc NUMBER;                    
        v_rok_aktualny NUMBER := EXTRACT(YEAR FROM SYSDATE);
        v_rok_produkcji NUMBER := EXTRACT(YEAR FROM DATA_PRODUKCJI); 
        v_wiek NUMBER := v_rok_aktualny - v_rok_produkcji;  
    BEGIN
        v_wartosc := CENA * POWER(0.9, v_wiek);   
        RETURN v_wartosc;                          
    END wartosc;
    
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN ROUND(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI) + (KILOMETRY / 10000), 2);
    END odwzoruj;
END;
/
DROP TABLE SAMOCHODY;
create table samochody of samochod;
insert into samochody values   
    (new samochod('ford', 'mondeo', 80000, date '1997-05-10', 45000, null));
    
select * from samochody;

select * from wlasciciele;

update samochody s 
set s.wlasciciel_atr = (
    select ref(w) from wlasciciele w
    where w.imie = 'Jan'
);

select * from samochody;

--6
set serveroutput on size 30000;
/
DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
    
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    moje_przedmioty.TRIM(2);
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;
/
--Zad7
declare
    type t_ksiazki is varray(5) of varchar2(50);
    moje_ksiazki t_ksiazki := t_ksiazki('title');
begin
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.extend(4);
    moje_ksiazki(2) := 'Król Szczurów';
    for i in 3..5 loop
        moje_ksiazki(i) := 'Book_' || i;
    end loop;
    
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.trim(1);
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());

end;
/
--Zad8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;
/
--Zad9
declare
    type t_miesiace is table of varchar2(20);
    moje_miesiace t_miesiace := t_miesiace();

begin
    moje_miesiace.extend(12);
    moje_miesiace(1) := 'styczen';
    moje_miesiace(2) := 'luty';
    moje_miesiace(3) := 'marzec';
    moje_miesiace(4) := 'kwiecien';
    moje_miesiace(5) := 'maj';
    moje_miesiace(6) := 'czerwiec';
    
    for i in 7..12 loop
        moje_miesiace(i) := 'Miesiac_' || i;
    end loop;
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;
    
    moje_miesiace.delete(7, 12);
    moje_miesiace(7) := 'lipiec';
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;

end;
/

--Zad10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--zad11
create type koszyk_produktow as table of varchar2(20);
/

create type zakup as object (
    osoba varchar2(50),
    produkty koszyk_produktow
);
/

create table zakupy of zakup
nested table produkty store as tab_produkty;
/
insert into zakupy values
(zakup('Mateusz Czajka', koszyk_produktow('maslo', 'chleb', 'banan')));
insert into zakupy values
(zakup('Jan Kowalski', koszyk_produktow('kowadlo', 'stal', 'zelazo')));
insert into zakupy values
(zakup('Antoni Nowak', koszyk_produktow('maslo')));

select * from zakupy;

delete from zakupy 
where osoba in (
    select osoba
    from zakupy z, table(z.produkty) p
    where p.column_value = 'maslo'
);
/
--Zad12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
 /
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
 /
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
 /
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;
/
--Zad13
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
 /
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
 /
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
/
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;
/
--Zad14
DECLARE
 tamburyn instrument; 
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;
/
--Zad15
CREATE TABLE instrumenty OF instrument;
/
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES (instrument_dety('trabka', 'tra-ta-ta', 'metalowa'));

);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;




