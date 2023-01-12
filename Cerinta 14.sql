--14) Pentru cartile de gen 'Poezie' sa se afiseze 'da' daca cartea s-a lansat intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor si 'nu' daca nu e egala.
-- Iar pentru cele de gen 'Fictiune' sa se afiseze 'nu' daca cartea s-a lansat intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor si 'da' daca nu e egala.

CREATE OR REPLACE PACKAGE pack14_proiect AS
    paritate_diferenta BOOLEAN;
    TYPE tabel_poezii IS TABLE OF carti%ROWTYPE;
    CURSOR c_romane IS SELECT * FROM carti WHERE gen = 'Fictiune';

    FUNCTION paritate_diferenta_varsta RETURN NUMBER;
    FUNCTION paritate_an(v_carte carti%ROWTYPE) RETURN BOOLEAN;
    PROCEDURE afisare_raspuns_poezie;
    PROCEDURE afisare_raspuns_roman;
END pack14_proiect;

CREATE OR REPLACE PACKAGE BODY pack14_proiect AS
    FUNCTION paritate_diferenta_varsta RETURN NUMBER IS
        v_max_bib NUMBER;
        v_min_stud NUMBER;
    BEGIN
        SELECT MAX(varsta) INTO v_max_bib FROM bibliotecari;
        SELECT MIN(varsta) INTO v_min_stud FROM studenti;
        RETURN MOD(v_max_bib - v_min_stud, 2);
    END paritate_diferenta_varsta;

    FUNCTION paritate_an(v_carte carti%ROWTYPE) RETURN BOOLEAN IS
    BEGIN
        RETURN MOD(v_carte.AN_PUBLICARE, 2) = paritate_diferenta_varsta;
    END paritate_an;

    PROCEDURE afisare_raspuns_poezie IS
        v_carte carti%ROWTYPE;
        t_poezii tabel_poezii;
    BEGIN
        SELECT * BULK COLLECT INTO t_poezii FROM carti WHERE gen = 'Poezie';

        FOR i IN t_poezii.FIRST..t_poezii.LAST LOOP
            IF paritate_an(t_poezii(i)) THEN
                DBMS_OUTPUT.PUT_LINE('DA! Cartea ' || t_poezii(i).NUME_CARTE || ' a fost lansata intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor!');
            ELSE
                DBMS_OUTPUT.PUT_LINE('NU! Cartea ' || t_poezii(i).NUME_CARTE || ' nu a fost lansata intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor!');
            END IF;
        END LOOP;

    END afisare_raspuns_poezie;

    PROCEDURE afisare_raspuns_roman IS
        v_carte carti%ROWTYPE;

    BEGIN
        FOR i IN c_romane LOOP
            IF paritate_an(i) = false THEN
                DBMS_OUTPUT.PUT_LINE('DA! Cartea ' || i.NUME_CARTE || ' nu a fost lansata intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor!');
            ELSE
                DBMS_OUTPUT.PUT_LINE('NU! Cartea ' || i.NUME_CARTE || ' a fost lansata intr-un an cu o paritate egala cu paritatea diferentei dintre varsta maxima a bibliotecarilor si cea minima a studentilor!');
            END IF;
        END LOOP;

    END afisare_raspuns_roman;

END pack14_proiect;
/
-- utilizare pachet:

BEGIN
    pack14_proiect.afisare_raspuns_poezie;
END;

/

BEGIN
    pack14_proiect.afisare_raspuns_roman;
END;

/