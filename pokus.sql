--- Smazani objektu pro novy start
  DROP TABLE Kocka                  CASCADE CONSTRAINTS;
  DROP TABLE Zivot                  CASCADE CONSTRAINTS;
  DROP TABLE Teritorium             CASCADE CONSTRAINTS;
  DROP TABLE Vlastnictvi            CASCADE CONSTRAINTS;
  DROP TABLE Hostitel               CASCADE CONSTRAINTS;
  DROP TABLE Rasa                   CASCADE CONSTRAINTS;
  DROP TABLE Specificke_rysy        CASCADE CONSTRAINTS;
  DROP TABLE Pohyb_kocky            CASCADE CONSTRAINTS;
  DROP TABLE Interval_vlastnictvi   CASCADE CONSTRAINTS;
  DROP TABLE Slouzi                 CASCADE CONSTRAINTS;
  DROP TABLE Rysy_rasy              CASCADE CONSTRAINTS;
  DROP TABLE Preference             CASCADE CONSTRAINTS;
  DROP TABLE Minuly                 CASCADE CONSTRAINTS;
  DROP TABLE Aktualni               CASCADE CONSTRAINTS;

--- Tvorba tabulek
CREATE TABLE Kocka
        (
            hlavni_jmeno VARCHAR(160) NOT NULL PRIMARY KEY,
            vzorek_kuze VARCHAR(10) NOT NULL,
            barva_srsti VARCHAR(50) NOT NULL,

            ID_rasy VARCHAR(4) NOT NULL --FK rasy
        );

CREATE TABLE Zivot
        (
            ID_zivot VARCHAR(10) NOT NULL PRIMARY KEY,
            poradi INT NOT NULL,
            delka VARCHAR(10) NOT NULL,

            jmeno_kocky VARCHAR(160) NOT NULL -- FK kocky
        );

CREATE TABLE Teritorium
        (
            ID_teritorium VARCHAR(4) NOT NULL PRIMARY KEY,
            typ_teritoria VARCHAR(50) NOT NULL,
            kapacita_kocek INT NOT NULL
        );

CREATE TABLE Vlastnictvi
        (
            ID_vlastnictvi VARCHAR(4) NOT NULL PRIMARY KEY,
            typ_vlastnictvi VARCHAR(50) NOT NULL,
            kvantita INT NOT NULL,

            ID_hostitele VARCHAR(4), -- FK hostitele --NOT NULL zde chybi protoze se jedna o vazbu 0-1, tudiz muze nastat ze zda vazba nebude
            jmeno_kocky VARCHAR(160), -- FK kocky    --Zde se jedna o stejny pripad
            ID_teritoria VARCHAR(4) NOT NULL -- FK teritoria
        );

CREATE TABLE Hostitel
        (
            ID_hostitel VARCHAR(4) NOT NULL PRIMARY KEY,
            jmeno VARCHAR(50) NOT NULL,
            vek INT NOT NULL,
            pohlavi VARCHAR(4) NOT NULL,
            misto_bydleni VARCHAR(50) NOT NULL
        );

CREATE TABLE Rasa
        (
            ID_rasy VARCHAR(4) NOT NULL PRIMARY KEY,
            puvod VARCHAR(50) NOT NULL,
            max_delka_tesaku VARCHAR(4) NOT NULL
        );

CREATE TABLE Specificke_rysy
        (
            ID_rysy VARCHAR(4) NOT NULL PRIMARY KEY,
            barva_oci VARCHAR(50) NOT NULL
        );


-- TABULKY M:N VAZEB --

CREATE TABLE Pohyb_kocky
        (
            interval_pobytu VARCHAR(10) NOT NULL PRIMARY KEY,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_teritoria VARCHAR(4) NOT NULL  --Fk teritoria
        );

CREATE TABLE Interval_vlastnictvi
        (
            doba VARCHAR(10) NOT NULL PRIMARY KEY,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_vlastnictvi VARCHAR(4) NOT NULL  --FK vlastnictvi
        );

CREATE TABLE Slouzi
        (
            prezdivka VARCHAR(50) NOT NULL PRIMARY KEY,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_hostitele VARCHAR(4) NOT NULL --FK hostitel
        );

CREATE TABLE Rysy_rasy
        (
            ID_rasy VARCHAR(4) NOT NULL, -- FK rasy
            ID_rysy VARCHAR(50) NOT NULL  -- FK
        );

CREATE TABLE Preference
        (
            ID_hostitele VARCHAR(4) NOT NULL, -- FK hostitele
            ID_rasy VARCHAR(4) NOT NULL  -- FK rasy
        );

-- GENERALIZACE/SPECIALIZACE --
CREATE TABLE Minuly
        (
            ID_zivot VARCHAR(4) NOT NULL, --FK zivot

            zpusob_smrti VARCHAR(100) NOT NULL,
            misto_umrti VARCHAR(4) NOT NULL
        );

CREATE TABLE Aktualni
        (
            ID_zivot VARCHAR(4) NOT NULL, -- FK zivot

            misto_narozeni VARCHAR(4) NOT NULL -- FK teritoria
        );

------- FK ------
-- kocky --
    ALTER TABLE Kocka ADD CONSTRAINT fk_je_rasy FOREIGN KEY (ID_rasy) REFERENCES Rasa;
-- zivot --
    ALTER TABLE Zivot ADD CONSTRAINT fk_ma_kocku FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
-- vlastnictvi --
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_je_propujceno FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_ma FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_se_nachazi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
-- M:N vazby --
--pohyb_kocky--
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_se_pohybuje FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_v_prostredi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
--interval_vlastnictvi--
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_je_vlastneno FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_pripada FOREIGN KEY (ID_vlastnictvi) REFERENCES Vlastnictvi;
--slouzi--
    ALTER TABLE Slouzi ADD CONSTRAINT fk_slouzi FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Slouzi ADD CONSTRAINT fk_je_panem FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
--rysy_rasy--
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_rasa_ma FOREIGN KEY (ID_rasy) REFERENCES Rasa;
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_jsou FOREIGN KEY (ID_rysy) REFERENCES Specificke_rysy;
--preference--
    ALTER TABLE Preference ADD CONSTRAINT fk_hostitel FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Preference ADD CONSTRAINT fk_preferuje FOREIGN KEY (ID_rasy) REFERENCES Rasa;
-- Minuly --
    ALTER TABLE Minuly ADD CONSTRAINT fk_zil FOREIGN KEY (ID_zivot) REFERENCES Zivot;
    ALTER TABLE Minuly ADD CONSTRAINT fk_misto_umrti FOREIGN KEY (misto_umrti) REFERENCES Teritorium;
-- Aktualni --
    ALTER TABLE Aktualni ADD CONSTRAINT fk_zije FOREIGN KEY (ID_zivot) REFERENCES Zivot;
    ALTER TABLE Aktualni ADD CONSTRAINT fk_misto_narozeni FOREIGN KEY (misto_narozeni) REFERENCES Teritorium;










---- CHECKy
 --ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK ((pohlavi = 0) OR (pohlavi = 1));
 ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK (REGEXP_LIKE(pohlavi, '^([m|M][u|U][z|Z]|[z|Z][e|E][n|N][a|A])$'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_vek CHECK ((vek >= 1) AND (vek <= 130));
 ALTER TABLE Zivot ADD CONSTRAINT check_pocet_zivotu CHECK ((poradi >= 1) AND (poradi <= 9));
 ALTER TABLE Zivot ADD CONSTRAINT check_zapis_zivota CHECK (REGEXP_LIKE(delka, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));
 ALTER TABLE Rasa ADD CONSTRAINT check_cm CHECK (REGEXP_LIKE(max_delka_tesaku, '^[0-9]{1,2}[c,C][m,M]$'));

 ALTER TABLE Zivot ADD CONSTRAINT check_ID_1 CHECK (REGEXP_LIKE(ID_zivot,'Z[0-9]{3}'));
 ALTER TABLE Teritorium ADD CONSTRAINT check_ID_2 CHECK (REGEXP_LIKE(ID_teritorium,'T[0-9]{3}'));
 ALTER TABLE Vlastnictvi ADD CONSTRAINT check_ID_3 CHECK (REGEXP_LIKE(ID_vlastnictvi,'V[0-9]{3}'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_ID_4 CHECK (REGEXP_LIKE(ID_hostitel,'H[0-9]{3}'));
 ALTER TABLE Rasa ADD CONSTRAINT check_ID_5 CHECK (REGEXP_LIKE(ID_rasy,'R[0-9]{3}'));
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_ID_6 CHECK (REGEXP_LIKE(ID_rysy,'S[0-9]{3}'));

 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_interval_pobytu CHECK (REGEXP_LIKE(interval_pobytu, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));

 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_interval_vlastnictvi CHECK (REGEXP_LIKE(doba, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));






--INSERT Rasy--
INSERT INTO Rasa (ID_rasy, puvod, max_delka_tesaku) VALUES ('R001', 'Egypt', '27cm');
INSERT INTO Rasa (ID_rasy, puvod, max_delka_tesaku) VALUES ('R002', 'Cesko', '12cm');
INSERT INTO Rasa (ID_rasy, puvod, max_delka_tesaku) VALUES ('R125', 'Cina', '15cm');
INSERT INTO Rasa (ID_rasy, puvod, max_delka_tesaku) VALUES ('R457', 'Nemecko', '7cm');
INSERT INTO Rasa (ID_rasy, puvod, max_delka_tesaku) VALUES ('R521', 'Italie', '6cm');

--INSERT Kocek--
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('julca','BLK', 'fialova', 'R001');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('packa','TW', 'cerna', 'R002');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('micka','SKYB', 'bila', 'R125');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('fous','BLK', 'cerna', 'R457');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('tlapka','YLW', 'oranzova', 'R521');

--INSERT Zivota dane kocky--
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z001', 1, '7r140d', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z003', 2, '1r123d', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z002', 1, '13r254d', 'packa');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z123', 1, '25d', 'micka');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z222', 1, '1d', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z223', 2, '2r12d', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z246', 3, '1r', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z564', 1, '8r45d', 'tlapka');

--INSERT Teritorii--
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T001', 'obyvak', 20);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T002', 'kuchyn', 10);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T156', 'zahrada', 50);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T546', 'ulice', 200);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T991', 'toaleta', 3);

--INSERT Hostitelu--
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H001', 'Pavel', 42, 'muz', 'Znojmo');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H002', 'Marek', 22, 'muz', 'Brno');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H055', 'Boris', 21, 'muz', 'Praha');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H150', 'Dan', 21, 'muz', 'Ostrava');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H854', 'Jan', 22, 'muz', 'Plzen');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H855', 'Katka', 56, 'zena', 'Most');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H954', 'Monika', 17, 'zena', 'Jundrov');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H958', 'Rebeka', 32, 'zena', 'Hradec Kralove');

--INSERT typu vlastnictvi--
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V001', 'balonek', 3, 'H001', 'julca', 'T001');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V002', 'klubicko bavlny', 2, '', 'julca', 'T001');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V269', 'letajici talir', 1, 'H150', 'micka', 'T991');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V400', 'bumerang', 1, 'H854', 'tlapka', 'T156');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V562', 'klacik', 12, '', '', 'T002');

--INSERT specifickych rysu--
INSERT INTO Specificke_rysy (ID_rysy, barva_oci) VALUES ('S001', 'zelena');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci) VALUES ('S002', 'modra');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci) VALUES ('S247', 'hneda');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci) VALUES ('S542', 'cervena');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci) VALUES ('S734', 'cerna');


INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('324d', 'packa', 'T001');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('54d', 'julca', 'T001');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('2d', 'micka', 'T002');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('1r244d', 'fous', 'T991');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('2r', 'tlapka', 'T156');

INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('324d', 'julca', 'V001');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('54d', 'julca', 'V002');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('1r25d', 'micka', 'V269');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('4d', 'tlapka', 'V400');


INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('kulisak', 'julca', 'H001');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('zrout', 'packa', 'H001');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('otrava', 'micka', 'H002');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('kulicka', 'fous', 'H954');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('milacek', 'tlapka', 'H854');

INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R001', 'S734');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R002', 'S001');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R125', 'S542');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R457', 'S002');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R521', 'S247');


INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H001', 'R001');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H002', 'R457');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H055', 'R002');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H150', 'R001');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H854', 'R521');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H855', 'R457');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H954', 'R002');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H958', 'R125');

INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z003', 'T001');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z002', 'T156');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z123', 'T546');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z246', 'T002');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z564', 'T991');

INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z001', 'Prejeta autem.' ,'T546');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z222', 'Utopena v zachodu.' ,'T991');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z223', 'Rozmacknuta padem houpacky' ,'T156');
