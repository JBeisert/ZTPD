set serveroutput on size 300000;

--zad1
create table movies as select * from ztpd.movies;

create table MOVIES
(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

INSERT INTO MOVIES SELECT * FROM ztpd.movies;

--zad2
select * from ztpd.movies;
descr ztpd.movies;

--zad3
select ID, title 
from ztpd.movies 
where COVER is null;

--zad4
select ID, title, length(cover) as FILESIZE 
from ztpd.movies 
where COVER is not null;

--zad5
select id, title, dbms_lob.getlength(cover) as filesize
from ztpd.movies
where cover is null;

select ID, title, length(cover)  as FILESIZE 
from ztpd.movies 
where COVER is  null;

--zad6
select * 
from ALL_DIRECTORIES;

--zad7
UPDATE MOVIES
set
    COVER = EMPTY_BLOB(),
    MIME_TYPE = 'image/jpeg'
where ID = 66;

--zad8
select ID, title, length(cover) 
from movies 
where ID in (65,66);

--zad9
DECLARE
     lobd blob;
     fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
     SELECT cover into lobd from movies
     where id = 66
     FOR UPDATE;
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
     DBMS_LOB.FILECLOSE(fils);
     COMMIT;
END;

--zad10
CREATE TABLE TEMP_COVERS
(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--zad11
INSERT INTO temp_covers 
VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');
COMMIT;

--zad12
select movie_id, DBMS_LOB.GETLENGTH(image) 
from temp_covers

--zad13
DECLARE
     mime VARCHAR2(50);
     image BFILE;
     lobd blob;
BEGIN
    
    SELECT mime_type into mime from temp_covers;
    SELECT image into image from temp_covers;
    
    dbms_lob.createtemporary(lobd, TRUE);
    
    DBMS_LOB.fileopen(image, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    update movies
    set cover = lobd,
    mime_type = mime
    where id = 65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;

--zad14
select ID, title, length(cover) 
from movies 
where ID = 65 or ID = 66;

--zad15
drop table MOVIES;
drop table TEMP_COVERS;