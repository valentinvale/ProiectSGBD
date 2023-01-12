--13) Pachet 1

CREATE OR REPLACE PACKAGE pack13_proiect AS
    PROCEDURE carti_secol(v_secol NUMBER);
    PROCEDURE secole_student(v_varsta_minima NUMBER, v_varsta_maxima NUMBER);
    FUNCTION nr_carti_autor(v_nume_autor autori.nume_si_prenume_autor%TYPE) RETURN NUMBER;
    PROCEDURE afisare_fac_bib(v_nume_facultate facultati.nume_facultate%TYPE);
END pack13_proiect;
/
CREATE OR REPLACE PACKAGE BODY pack13_proiect AS
    PROCEDURE carti_secol
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

            PROCEDURE secole_student
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

    FUNCTION nr_carti_autor
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

    PROCEDURE afisare_fac_bib
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

END pack13_proiect;

/ -- 6)
BEGIN
    pack13_proiect.carti_secol(20);
END;
/ -- 7)
BEGIN
    pack13_proiect.secole_student(10,19);
END;

-- 8)
/ -- bun
BEGIN
    DBMS_OUTPUT.PUT_LINE(pack13_proiect.nr_carti_autor('Ernest Hemingway'));
END;
/ -- nu exista autorul
BEGIN
    DBMS_OUTPUT.PUT_LINE(pack13_proiect.nr_carti_autor('Nelu Mineru'));
END;
/ -- nu au fost imprumutate carti de la el
BEGIN
    DBMS_OUTPUT.PUT_LINE(pack13_proiect.nr_carti_autor('Jack Kerouac'));
END;

-- 9)
/ -- Nu indeplineste conditiile
BEGIN
    pack13_proiect.afisare_fac_bib('facultatea de matematica');
END;
/ -- Mai multe facultati cu acelasi nume
BEGIN
    pack13_proiect.afisare_fac_bib('facultatea de medicina');
END;
/-- Bun
BEGIN
    pack13_proiect.afisare_fac_bib('facultatea drobeta');
END;
/ -- Facultatea nu are carti
BEGIN
    pack13_proiect.afisare_fac_bib('Facultatea fara carti');
END;

/ -- Facultatea nu exista in baza de date
BEGIN
    pack13_proiect.afisare_fac_bib('Facultatea care nu exista');
end;
/