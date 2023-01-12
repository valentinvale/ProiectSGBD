CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (AUTO_ID.nextval, 'Facultatea de Matematica', 3);
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (AUTO_ID.nextval, 'Facultatea de Medicina', 6);
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (AUTO_ID.nextval, 'Facultatea Drobeta', 4);
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (AUTO_ID.nextval, 'Facultatea de Filosofie', 5);
INSERT INTO facultati(id_facultate, nume_facultate, durata) VALUES (AUTO_ID.nextval, 'Universitatea Craiova', 4);

DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (AUTO_ID.nextval, 1, 'Mihai Popescu', 19);
INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (AUTO_ID.nextval, 2, 'Ionut Nicu', 20);
INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (AUTO_ID.nextval, 5, 'Valentin Ion', 20);
INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (AUTO_ID.nextval, 1, 'Mihnea Mihali', 19);
INSERT INTO studenti(id_student, id_facultate, nume_si_prenume_student, varsta) VALUES (AUTO_ID.nextval, 3, 'Marius Miopu', 21);

DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Mihai Eminescu');
INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Fyodor Dostoevsky');
INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Albert Camus');
INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Sylvia Plath');
INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Ernest Hemingway');
INSERT INTO autori(id_autor, nume_si_prenume_autor) VALUES (AUTO_ID.nextval, 'Nichita Stanescu');


DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO edituri(id_editura, nume_editura, tara) VALUES (AUTO_ID.nextval, 'Corint', 'Romania');
INSERT INTO edituri(id_editura, nume_editura, tara) VALUES (AUTO_ID.nextval, 'Polirom', 'Romania');
INSERT INTO edituri(id_editura, nume_editura, tara) VALUES (AUTO_ID.nextval, 'Nemira', 'Franta');
INSERT INTO edituri(id_editura, nume_editura, tara) VALUES (AUTO_ID.nextval, 'Pinguin', 'Germania');
INSERT INTO edituri(id_editura, nume_editura, tara) VALUES (AUTO_ID.nextval, 'Gold Fish', 'Anglia');

DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO colectii(id_colectie, nume_colectie) VALUES (AUTO_ID.nextval, 'Carti de neuitat');
INSERT INTO colectii(id_colectie, nume_colectie) VALUES (AUTO_ID.nextval, '1000 de carti de citit');
INSERT INTO colectii(id_colectie, nume_colectie) VALUES (AUTO_ID.nextval, 'Fictiunea');
INSERT INTO colectii(id_colectie, nume_colectie) VALUES (AUTO_ID.nextval, 'Poezii patrunzatoare');
INSERT INTO colectii(id_colectie, nume_colectie) VALUES (AUTO_ID.nextval, 'Romanesti');

DROP SEQUENCE AUTO_ID;

INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891234, 1, 1, 5, 'Poesii', 'Poezie', 1883);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891235, 1, 1, 5, 'Somnoroase Pasarele', 'Poezie', 1883);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891278, 2, 2, 1, 'Idiotul', 'Fictiune', 1867);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891279, 2, 2, 1, 'Insemnari din Subterana', 'Fictiune', 1864);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891200, 3, 2, 2, 'Mitul lui Sisif', 'Filosofie', 1942);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567891209, 3, 4, 2, 'Strainul', 'Fictiune', 1942);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567892122, 3, 1, 2, 'Ciuma', 'Fictiune', 1947);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567892123, 4, 2, 3, 'Clopotul de Sticla', 'Roman a clef', 1963);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567892198, 4, 2, 4, 'Ariel', 'Poezie', 1965);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567890028, 5, 5, 3, 'Batranul si Marea', 'Fictiune', 1952);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567890038, 5, 5, 1, 'Puhoaiele Primaverii', 'Parodie', 1926);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567890508, 6, 3, 4, 'Leoaica tanara, Iubirea: Poezii de dragoste', 'Poezie', 1964);
INSERT INTO carti(isbn, id_autor, id_editura, id_colectie, nume_carte, gen, an_publicare) VALUES (1234567809008, 6, 3, 4, 'Lectie despre cub', 'Poezie abstracta', 1979);


CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (AUTO_ID.nextval, 1, 'Gheorghe Titeica');
INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (AUTO_ID.nextval, 2, 'Marius Emsi');
INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (AUTO_ID.nextval, 3, 'Ilie Balaci');
INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (AUTO_ID.nextval, 4, 'Lorin Andrei');
INSERT INTO biblioteci(id_biblioteca, id_facultate, nume_biblioteca) VALUES (AUTO_ID.nextval, 5, 'Mihnea Mihail');


DROP SEQUENCE AUTO_ID;


CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO conturi(id_cont, username) VALUES (AUTO_ID.nextval, 'nicu123');
INSERT INTO conturi(id_cont, username) VALUES (AUTO_ID.nextval, 'CititorulNebun');
INSERT INTO conturi(id_cont, username) VALUES (AUTO_ID.nextval, 'Vasile_nelut');
INSERT INTO conturi(id_cont, username) VALUES (AUTO_ID.nextval, 'MirelRA2');
INSERT INTO conturi(id_cont, username) VALUES (AUTO_ID.nextval, 'ANTIFCU');

DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO contracte_imprumut(id_contract, taxa_intarziere, durata) VALUES (AUTO_ID.nextval, 50, 30);
INSERT INTO contracte_imprumut(id_contract, taxa_intarziere, durata) VALUES (AUTO_ID.nextval, 100, 60);
INSERT INTO contracte_imprumut(id_contract, taxa_intarziere, durata) VALUES (AUTO_ID.nextval, 15, 20);
INSERT INTO contracte_imprumut(id_contract, taxa_intarziere, durata) VALUES (AUTO_ID.nextval, 150, 60);
INSERT INTO contracte_imprumut(id_contract, taxa_intarziere, durata) VALUES (AUTO_ID.nextval, 10, 5);

DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO bibliotecari VALUES (AUTO_ID.nextval, 1, 'Andrei Gheorghe', 40);
INSERT INTO bibliotecari VALUES (AUTO_ID.nextval, 2, 'Hagi Dobrin', 27);
INSERT INTO bibliotecari VALUES (AUTO_ID.nextval, 3, 'Tiberiu Iordache', 30);
INSERT INTO bibliotecari VALUES (AUTO_ID.nextval, 4, 'Andrei Ivan', 31);
INSERT INTO bibliotecari VALUES (AUTO_ID.nextval, 5, 'Vlad Marian', 38);


DROP SEQUENCE AUTO_ID;

CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO istoricuri VALUES (AUTO_ID.nextval, 'istoric1');
INSERT INTO istoricuri VALUES (AUTO_ID.nextval, 'istoric2');
INSERT INTO istoricuri VALUES (AUTO_ID.nextval, 'istoric3');
INSERT INTO istoricuri VALUES (AUTO_ID.nextval, 'istoric4');
INSERT INTO istoricuri VALUES (AUTO_ID.nextval, 'istoric5');


DROP SEQUENCE AUTO_ID;


CREATE SEQUENCE AUTO_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

INSERT INTO abonamente VALUES (AUTO_ID.nextval, 'premium');
INSERT INTO abonamente VALUES (AUTO_ID.nextval, 'standard');
INSERT INTO abonamente VALUES (AUTO_ID.nextval, 'bronz');
INSERT INTO abonamente VALUES (AUTO_ID.nextval, 'argint');
INSERT INTO abonamente VALUES (AUTO_ID.nextval, 'aur');


DROP SEQUENCE AUTO_ID;


INSERT INTO creeaza VALUES(1, 1, 1);
INSERT INTO creeaza VALUES(2, 2, 2);
INSERT INTO creeaza VALUES(3, 3, 3);
INSERT INTO creeaza VALUES(4, 4, 4);
INSERT INTO creeaza VALUES(5, 5, 5);
INSERT INTO creeaza VALUES(1, 2, 3);
INSERT INTO creeaza VALUES(2, 3, 1);
INSERT INTO creeaza VALUES(2, 4, 3);
INSERT INTO creeaza VALUES(4, 5, 1);
INSERT INTO creeaza VALUES(1, 2, 5);

INSERT INTO imprumuta_tern VALUES(1234567891234, 1, 1);
INSERT INTO imprumuta_tern VALUES(1234567891234, 2, 2);
INSERT INTO imprumuta_tern VALUES(1234567891234, 2, 5);
INSERT INTO imprumuta_tern VALUES(1234567891234, 3, 3);
INSERT INTO imprumuta_tern VALUES(1234567891234, 3, 4);
INSERT INTO imprumuta_tern VALUES(1234567892123, 3, 3);
INSERT INTO imprumuta_tern VALUES(1234567890508, 1, 2);
INSERT INTO imprumuta_tern VALUES(1234567890508, 1, 4);
INSERT INTO imprumuta_tern VALUES(1234567890508, 3, 1);
INSERT INTO imprumuta_tern VALUES(1234567892123, 5, 5);
INSERT INTO imprumuta_tern VALUES(1234567892123, 5, 3);

INSERT INTO se_inscrie VALUES(1, 1);
INSERT INTO se_inscrie VALUES(2, 2);
INSERT INTO se_inscrie VALUES(3, 3);
INSERT INTO se_inscrie VALUES(4, 4);
INSERT INTO se_inscrie VALUES(5, 5);
INSERT INTO se_inscrie VALUES(1, 2);
INSERT INTO se_inscrie VALUES(2, 1);
INSERT INTO se_inscrie VALUES(3, 1);
INSERT INTO se_inscrie VALUES(4, 2);
INSERT INTO se_inscrie VALUES(5, 2);

INSERT INTO imprumuta VALUES(1, 1234567891234);
INSERT INTO imprumuta VALUES(2, 1234567891209);
INSERT INTO imprumuta VALUES(3, 1234567890508);
INSERT INTO imprumuta VALUES(4, 1234567891278);
INSERT INTO imprumuta VALUES(5, 1234567809008);
INSERT INTO imprumuta VALUES(2, 1234567890028);
INSERT INTO imprumuta VALUES(1, 1234567890028);
INSERT INTO imprumuta VALUES(3, 1234567891235);
INSERT INTO imprumuta VALUES(3, 1234567892198);
INSERT INTO imprumuta VALUES(4, 1234567891234);

INSERT INTO poate_fi_gasita VALUES(1, 1234567891234);
INSERT INTO poate_fi_gasita VALUES(2, 1234567891234);
INSERT INTO poate_fi_gasita VALUES(3, 1234567809008);
INSERT INTO poate_fi_gasita VALUES(4, 1234567891235);
INSERT INTO poate_fi_gasita VALUES(5, 1234567809008);
INSERT INTO poate_fi_gasita VALUES(2, 1234567809008);
INSERT INTO poate_fi_gasita VALUES(1, 1234567890028);
INSERT INTO poate_fi_gasita VALUES(3, 1234567890028);
INSERT INTO poate_fi_gasita VALUES(4, 1234567890028);
INSERT INTO poate_fi_gasita VALUES(1, 1234567892198);

select * from studenti;

select * from facultati;

select * from autori;

select * from edituri;

select * from colectii;

select * from carti;

select * from biblioteci;

select * from contracte_imprumut;

select * from conturi;

select * from bibliotecari;

select * from istoricuri;

select * from abonamente;

select * from creeaza;

select * from imprumuta_tern;

select * from se_inscrie;

select * from imprumuta;

select * from poate_fi_gasita;

