/


--6) Afisati si salvati titlurile cartilor care au fost publicate intr-un secol dat.

CREATE OR REPLACE PROCEDURE carti_secol
    (v_secol NUMBER)
AS
    TYPE tablou_indexat IS TABLE OF Carti%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE vector IS VARRAY(90) OF VARCHAR2(200);
    tablou tablou_indexat;
    vect vector := vector();
    v_carte Carti%ROWTYPE;
    contor NUMBER(2);
BEGIN
    contor := 0;
    select * bulk collect into tablou from carti;
    FOR i IN tablou.first..tablou.last LOOP
        IF SUBSTR(TO_CHAR(tablou(i).an_publicare), 1, 2) = (TO_CHAR(v_secol-1))
            THEN
                vect.extend;
                contor := contor + 1;
                vect(contor) := tablou(i).nume_carte;
        END IF;
    END LOOP;

    FOR i IN vect.FIRST..vect.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Numele cartii: ' || vect(i));
    END LOOP;
END carti_secol;
/
BEGIN
    carti_secol(20);
END;
/

--7) Pentru toti studentii cu varsta cuprinsa intre doua numere, sa se afiseze isbn-ul cartilor imprumutate

CREATE OR REPLACE PROCEDURE secole_student
    (v_varsta_minima NUMBER, v_varsta_maxima NUMBER)
AS
    TYPE tab_student IS TABLE OF studenti%ROWTYPE;
    t_student tab_student;
    cursor c_student(minn NUMBER, maxx NUMBER)
    IS
        select *
        from studenti
        where varsta between minn and maxx;

    cursor c_imprumuta IS
        SELECT *
        FROM imprumuta;
BEGIN
    OPEN c_student(v_varsta_minima, v_varsta_maxima);
    FETCH c_student BULK COLLECT INTO t_student;
    CLOSE c_student;
    FOR i IN t_student.FIRST..t_student.LAST LOOP
        FOR j IN c_imprumuta LOOP
            IF t_student(i).id_student = j.id_student
                THEN DBMS_OUTPUT.PUT_LINE('Studentul ' || t_student(i).nume_si_prenume_student || ' a imprumutat cartea ' || j.isbn);
            END IF;
        END LOOP;
    END LOOP;
END secole_student;
/
BEGIN
    secole_student(10, 19);
END;
/

--8) Pentru un autor dat, sa se afiseze cati studenti au imprumutat cel putin o carte de la autorul respctiv.

INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (7, 'Jack Kerouac');
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567809777, 7, 3, 4, 'Dharma Bums', 'Fictiune', 1958);
/

CREATE OR REPLACE FUNCTION nr_carti_autor
    (v_nume_autor autori.nume_si_prenume_autor%TYPE)
RETURN NUMBER IS
    v_nr_carti NUMBER;
    ok BOOLEAN;
    exceptie_no_author EXCEPTION;
    exceptie_no_books EXCEPTION;
    TYPE tab_autori IS TABLE OF autori%ROWTYPE INDEX BY PLS_INTEGER;
    t_autori tab_autori;

BEGIN
    ok := FALSE;
    select * BULK COLLECT INTO t_autori from autori;
    FOR i IN t_autori.FIRST..t_autori.LAST LOOP
        IF t_autori(i).nume_si_prenume_autor = v_nume_autor
            THEN ok := TRUE;
        END IF;
    END LOOP;
    IF ok = FALSE THEN
        RAISE exceptie_no_author;
    END IF;

    select count(s.id_student) into v_nr_carti
    from studenti s
    join imprumuta imp on imp.id_student = s.id_student
    join carti crt on crt.isbn = imp.isbn
    join autori aut on aut.id_autor = crt.id_autor and LOWER(aut.nume_si_prenume_autor) =LOWER(v_nume_autor);
    IF v_nr_carti = 0 THEN
        RAISE exceptie_no_books;
    END IF;
    RETURN v_nr_carti;
EXCEPTION
    WHEN exceptie_no_books THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu a imprumutat nimeni carti de la acest autor');
    WHEN exceptie_no_author THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nu exista autorul dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi autori cu acelasi numar');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END nr_carti_autor;
/ -- bun
BEGIN
    DBMS_OUTPUT.PUT_LINE(nr_carti_autor('Ernest Hemingway'));
END;
/ -- nu exista autorul
BEGIN
    DBMS_OUTPUT.PUT_LINE(nr_carti_autor('Nelu Mineru'));
END;
/ -- nu au fost imprumutate carti de la el
BEGIN
    DBMS_OUTPUT.PUT_LINE(nr_carti_autor('Jack Kerouac'));
END;
/
select * from autori;
select * from studenti;
select * from imprumuta;
select * from carti;


--9) Sa se afiseze daca facultatea cu numele introdus are biblioteca cu numarul de bibliotecari egal cu numarul de studenti de la facultate si numarul de carti de la acea biblioteca

CREATE OR REPLACE PROCEDURE afisare_fac_bib
    (v_nume_facultate facultati.nume_facultate%TYPE)
AS
    OK BOOLEAN;
    TYPE t_detalii_facultate IS RECORD(
        id_fac facultati.id_facultate%TYPE,
        nume_fac facultati.nume_facultate%TYPE,
        nr_bib NUMBER(5),
        nr_stud NUMBER(5),
        nr_carti NUMBER(5)
    );
    detalii_facultate t_detalii_facultate;
    TYPE tabel_facultati IS TABLE OF t_detalii_facultate INDEX BY PLS_INTEGER;
    t_facultati tabel_facultati;

    TYPE tabel_fac_cu_id IS TABLE OF facultati%ROWTYPE INDEX BY PLS_INTEGER;
    t_fac_cu_id tabel_fac_cu_id;

    NU_ARE_CARTI EXCEPTION;
    NU_SUNT_CONDITII EXCEPTION;



BEGIN
    ok := false;

    SELECT * BULK COLLECT INTO t_fac_cu_id FROM facultati WHERE LOWER(nume_facultate) = LOWER(v_nume_facultate);

    IF t_fac_cu_id.count > 1 THEN
        RAISE TOO_MANY_ROWS;
    END IF;

    IF t_fac_cu_id.count = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;


    SELECT fac.id_facultate, fac.nume_facultate, COUNT(DISTINCT bibliotecar.id_bibliotecar), COUNT(DISTINCT stud.id_student), COUNT(DISTINCT pfg.ISBN) BULK COLLECT INTO t_facultati
    FROM (select * from facultati where LOWER(v_nume_facultate) = LOWER(nume_facultate)) fac
    JOIN biblioteci b ON b.id_facultate = fac.id_facultate
    JOIN bibliotecari bibliotecar ON bibliotecar.id_biblioteca = b.id_biblioteca
    JOIN studenti stud ON stud.id_facultate = fac.id_facultate
    left outer JOIN poate_fi_gasita pfg ON pfg.id_biblioteca = b.id_biblioteca
    GROUP BY (fac.id_facultate, fac.nume_facultate);


    FOR i in t_facultati.FIRST..t_facultati.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(t_facultati(i).nume_fac);
        IF t_facultati(i).nr_bib = t_facultati(i).nr_stud THEN
            ok := true;
            IF t_facultati(i).nr_carti = 0 THEN
                RAISE NU_ARE_CARTI;
            END IF;
            DBMS_OUTPUT.PUT_LINE('DA! Facultatea ' || t_facultati(i).id_fac ||' are o biblioteca cu ' || t_facultati(i).nr_carti || ' titluri si are ' || t_facultati(i).nr_bib || ' bibliotecari si ' || t_facultati(i).nr_stud || ' studenti!');
        END IF;
    END LOOP;

     IF ok = false THEN
        RAISE NU_SUNT_CONDITII;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Facultatea nu exista in baza noastra de date!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe facultati cu numele dat!');
    WHEN NU_ARE_CARTI THEN
        RAISE_APPLICATION_ERROR(-20003, 'Facultatea nu are carti!');
    WHEN NU_SUNT_CONDITII THEN
        RAISE_APPLICATION_ERROR(-20004, 'Nu exista facultati care sa indeplineasca conditiile!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');

END afisare_fac_bib;
/
BEGIN
    afisare_fac_bib('facultatea de matematica');
END;
/
BEGIN
    afisare_fac_bib('facultatea de medicina');
END;
/
BEGIN
    afisare_fac_bib('facultatea drobeta');
END;
/
BEGIN
    afisare_fac_bib('Facultatea fara carti');
END;

/
BEGIN
    afisare_fac_bib('Facultatea care nu exista');
end;
/
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (6, 'Facultatea de Medicina', 6);
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (7, 'Facultatea fara carti', 6);
INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (7, 7, 'Biblioteca fara carti');
INSERT INTO bibliotecari VALUES (6, 7, 'Bib faracarti', 38);
INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (6, 3, 'Stud faracarti', 21);
INSERT INTO se_inscrie VALUES(6, 7);


select * from facultati;
select * from biblioteci;
select * from bibliotecari;
select * from studenti;
select * from carti;
select * from poate_fi_gasita;

/
SELECT fac.id_facultate, fac.nume_facultate, COUNT(DISTINCT bibliotecar.id_bibliotecar), COUNT(DISTINCT stud.id_student), COUNT(DISTINCT pfg.ISBN)
    FROM FACULTATI fac
    JOIN biblioteci b ON b.id_facultate = fac.ID_FACULTATE
    JOIN bibliotecari bibliotecar ON bibliotecar.id_biblioteca = b.id_biblioteca
    JOIN studenti stud ON stud.id_facultate = fac.id_facultate
    left outer JOIN poate_fi_gasita pfg ON pfg.id_biblioteca = b.id_biblioteca
    GROUP BY fac.id_facultate, fac.nume_facultate
    HAVING COUNT(DISTINCT bibliotecar.id_bibliotecar) = COUNT(DISTINCT stud.id_student);


/

--10) Creati un trigger LMD la nivel de comanda care sa nu permita inserarea a mai mult de 7 tipuri de abonamente
CREATE OR REPLACE TRIGGER trigger_abonamente
    BEFORE INSERT ON abonamente
DECLARE
    v_contor INT;
BEGIN
    SELECT count(id_abonament) into v_contor from abonamente;
    IF v_contor >= 7 THEN
        RAISE_APPLICATION_ERROR(-20001, 'S-a incercat inserarea a mai mult de 7 abonamente!');
    END IF;
END;
/
INSERT INTO abonamente VALUES (6, 'dummy1');
INSERT INTO abonamente VALUES (7, 'dummy2');
INSERT INTO abonamente VALUES (8, 'dummy4');

delete from abonamente where id_abonament between 6 and 8;

/

--11) Creati un trigger LMD la nivel de linie care sa nu permita micsorarea taxei de intarziere a contractelor de imprumut.


CREATE OR REPLACE TRIGGER trigger_contract
    BEFORE UPDATE OF TAXA_INTARZIERE ON contracte_imprumut
    FOR EACH ROW
BEGIN
    IF(:NEW.taxa_intarziere < :OLD.taxa_intarziere) THEN
    RAISE_APPLICATION_ERROR(-20102, 'taxa de intarziere nu poate fi micsorata!');
    END IF;
END;

/
UPDATE contracte_imprumut
SET taxa_intarziere = taxa_intarziere - 30;
/


--12) Creati un trigger LDD care sa permita alterarea tabelelor doar de catre utilizatorul 'UTILIZATOR'
 --Inserati modificarile in tabelul userhistory.

CREATE OR REPLACE TRIGGER trigger_user
    BEFORE CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    IF LOWER(USER) != LOWER('UTILIZATOR') THEN
        RAISE_APPLICATION_ERROR(-21000, 'Doar UTILIZATOR poate modifica tabelele!');
    END IF;
    INSERT INTO userhistory VALUES (user, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE TABLE userhistory(
    utilizator VARCHAR(50),
    event VARCHAR(50),
    obiect VARCHAR(50),
    ddata DATE);

DROP TABLE userhistory;

alter table abonamente add pret NUMBER(2);
alter table abonamente drop column pret;


/
BEGIN
    DBMS_OUTPUT.PUT_LINE(user);
END;
/
select * from userhistory;

/