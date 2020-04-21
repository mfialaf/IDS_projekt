-- Daniel Kamenicky ( xkamen21 ) & Marek Fiala ( xfiala60 ) --
-- VUT FIT 2019/2020 --
-- Projekt --
-- IDS --

--------------------------------------- CLEANING TABLES ----------------------------------------------------
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

  DROP SEQUENCE rasa_pk_seq;

----------------------------------------- TABLE CREATE -------------------------------------------------
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
            delka INT NOT NULL,

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
            ID_rasy VARCHAR(4) PRIMARY KEY,
            typ VARCHAR(50) NOT NULL
        );

CREATE TABLE Specificke_rysy
        (
            ID_rysy VARCHAR(4) NOT NULL PRIMARY KEY,
            barva_oci VARCHAR(50) NOT NULL,
            puvod VARCHAR(50) NOT NULL,
            max_delka_tesaku VARCHAR(4) NOT NULL
        );


-- TABULKY M:N VAZEB --

CREATE TABLE Pohyb_kocky
        (
            ID_pohyb_kocky VARCHAR(5) NOT NULL PRIMARY KEY,
            interval_pobytu INT NOT NULL,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_teritoria VARCHAR(4) NOT NULL  --Fk teritoria
        );

CREATE TABLE Interval_vlastnictvi
        (
            ID_interval_vlastnictvi VARCHAR(5) NOT NULL PRIMARY KEY ,
            doba VARCHAR(10) NOT NULL, -- pridan PK.. OPRVAVA

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_vlastnictvi VARCHAR(4) NOT NULL  --FK vlastnictvi
        );

CREATE TABLE Slouzi
        (
            ID_slouzi VARCHAR(5) NOT NULL PRIMARY KEY,
            prezdivka VARCHAR(50) NOT NULL,

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

            zpusob_smrti VARCHAR(100),
            misto_umrti VARCHAR(4) NOT NULL -- FK teritoria
        );

CREATE TABLE Aktualni
        (
            ID_zivot VARCHAR(4) NOT NULL, -- FK zivot

            misto_narozeni VARCHAR(4) NOT NULL -- FK teritoria
        );



----------------------------------------------- set FK --------------------------------------------
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



------------------------------------------------------ CHECKS ----------------------------------------------------------------------
 --ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK ((pohlavi = 0) OR (pohlavi = 1));
 ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK (REGEXP_LIKE(pohlavi, '^([m|M][u|U][z|Z]|[z|Z][e|E][n|N][a|A])$'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_vek CHECK ((vek >= 1) AND (vek <= 130));
 ALTER TABLE Zivot ADD CONSTRAINT check_pocet_zivotu CHECK ((poradi >= 1) AND (poradi <= 9));
 ALTER TABLE Zivot ADD CONSTRAINT check_zapis_zivota CHECK (delka > 0);
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_cm CHECK (REGEXP_LIKE(max_delka_tesaku, '^[0-9]{1,2}[c,C][m,M]$'));

 ALTER TABLE Zivot ADD CONSTRAINT check_ID_1 CHECK (REGEXP_LIKE(ID_zivot,'Z[0-9]+'));
 ALTER TABLE Teritorium ADD CONSTRAINT check_ID_2 CHECK (REGEXP_LIKE(ID_teritorium,'T[0-9]+'));
 ALTER TABLE Vlastnictvi ADD CONSTRAINT check_ID_3 CHECK (REGEXP_LIKE(ID_vlastnictvi,'V[0-9]+'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_ID_4 CHECK (REGEXP_LIKE(ID_hostitel,'H[0-9]+'));
 ALTER TABLE Rasa ADD CONSTRAINT check_ID_5 CHECK (REGEXP_LIKE(ID_rasy,'R[0-9]+'));
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_ID_6 CHECK (REGEXP_LIKE(ID_rysy,'S[0-9]+'));
 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_ID_7 CHECK (REGEXP_LIKE(ID_pohyb_kocky,'PK[0-9]+'));
 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_ID_8 CHECK (REGEXP_LIKE(ID_interval_vlastnictvi,'IV[0-9]+'));
 ALTER TABLE Slouzi ADD CONSTRAINT check_ID_9 CHECK (REGEXP_LIKE(ID_slouzi,'SL[0-9]+'));

 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_interval_pobytu CHECK (interval_pobytu > 0);

 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_interval_vlastnictvi CHECK (REGEXP_LIKE(doba, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));


-------------------------------------------------------INSERT-----------------------------------------------------------------------
--INSERT Rasy--
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R1', 'Birma');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R2', 'Siamska');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R3', 'Munchkin');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R4', 'Ragdoll');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R5', 'Sphynx');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R6', 'Toyger');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R7', 'Perska');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R8', 'RagaMuffin');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R9', 'Peterbald');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R10', 'Nebelung');

--INSERT Kocek--
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('julca','BLK', 'fialova', 'R1');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('packa','TW', 'cerna', 'R2');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('micka','SKYB', 'bila', 'R3');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('fous','BLK', 'cerna', 'R4');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('tlapka','YLW', 'oranzova', 'R5');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('max', 'BLK', 'zrzava', 'R6');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('richie', 'ZNK', 'seda', 'R9');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('silva', 'TW', 'zlatava', 'R8');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('pan zvon', 'BLK', 'cerna', 'R4');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('dextr', 'SKYB', 'seda', 'R7');

--INSERT Zivota dane kocky--
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z1', 1, '2555', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z2', 2, '465', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z3', 1, '4895', 'packa');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z4', 1, '25', 'micka');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z5', 1, '1', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z6', 2, '745', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z7', 3, '365', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z8', 1, '1698', 'tlapka');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z9', 1, '156', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z10', 2, '3120', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z11', 3, '3', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z12', 1, '999', 'richie');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z13', 1, '2222', 'silva');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z14', 2, '887', 'silva');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z15', 1, '1655', 'pan zvon');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z16', 1, '3522', 'dextr');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z17', 2, '1111', 'dextr');

--INSERT Teritorii--
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T1', 'obyvak', 20);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T2', 'kuchyn', 10);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T3', 'zahrada', 50);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T4', 'ulice', 200);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T5', 'toaleta', 3);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T6', 'garaz', 45);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T7', 'sklep', 30);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T8', 'puda', 70);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T9', 'predsin', 10);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T10', 'koupelna', 15);

--INSERT Hostitelu--
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H1', 'Pavel', 42, 'muz', 'Znojmo');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H2', 'Marek', 22, 'muz', 'Brno');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H3', 'Boris', 21, 'muz', 'Praha');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H4', 'Dan', 21, 'muz', 'Ostrava');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H5', 'Jan', 22, 'muz', 'Plzen');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H6', 'Katka', 56, 'zena', 'Most');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H7', 'Monika', 17, 'zena', 'Jundrov');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H8', 'Rebeka', 32, 'zena', 'Hradec Kralove');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H9', 'Lukas', 45, 'muz', 'LA');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H10', 'Michaela', 77, 'zena', 'Zlin');

--INSERT typu vlastnictvi--
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V1', 'balonek', 3, 'H1', 'julca', 'T1');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V2', 'klubicko bavlny', 2, '', 'julca', 'T1');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V3', 'letajici talir', 1, 'H4', 'micka', 'T5');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V4', 'bumerang', 1, 'H5', 'tlapka', 'T3');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V5', 'klacik', 12, '', '', 'T2');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V6', 'drazditko', 10, '', '', 'T8');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V7', 'plysova rybicka', 3, 'H9', 'richie', 'T9');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V8', 'myska', 4, 'H7', 'max', 'T8');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V9', 'polstarek', 1, '', '', 'T1');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V10', 'pirko na tycince', 4, 'H6', 'pan zvon', 'T7');

--INSERT specifickych rysu--
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S1', 'zelena', 'Egypt', '27cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S2', 'modra', 'Cesko', '12cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S3', 'hneda', 'Cina', '15cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S4', 'cervena', 'Nemecko', '7cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S5', 'cerna', 'Italie', '6cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S6', 'duhova', 'Izrael', '2cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S7', 'modro zelena', 'Pakistan', '9cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S8', 'zeleno hneda', 'Egypt', '11cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S9', 'tmave hneda', 'California', '4cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S10', 'svetle modra', 'Indie', '3cm');

--INSERT pohybu kocky--
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK1', '324', 'packa', 'T1');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK2', '480', 'packa', 'T1');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK3', '54', 'julca', 'T1');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK4', '178', 'micka', 'T2');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK5', '544', 'fous', 'T5');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK6', '200', 'fous', 'T5');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK7', '724', 'tlapka', 'T3');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK8', '10', 'max', 'T10');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK9', '684', 'silva', 'T7');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK10', '100', 'richie', 'T6');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK11', '178', 'silva', 'T8');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK12', '29', 'dextr', 'T9');

--INSERT intervalu vlastnictvi--
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV1', '324d', 'julca', 'V1');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV2', '54d', 'julca', 'V2');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV3', '1r25d', 'micka', 'V3');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV4', '2d', 'tlapka', 'V4');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV5', '15d', 'max', 'V9');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV6', '1d', 'silva', 'V10');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV7', '39d', 'pan zvon', 'V8');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV8', '2d', 'max', 'V7');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV9', '3r2d', 'dextr', 'V8');

--INSERT jaky hostitel slouzi jake kocce--
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL1', 'kulisak', 'julca', 'H1');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL2', 'zrout', 'packa', 'H1');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL3', 'otrava', 'micka', 'H2');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL4', 'kulicka', 'fous', 'H7');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL5', 'milacek', 'tlapka', 'H5');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL6', 'slinta', 'max', 'H6');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL7', 'lizal', 'dextr', 'H10');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL8', 'fantom', 'silva', 'H9');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL9', 'zrout', 'richie', 'H4');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL10', 'lenoch', 'pan zvon', 'H3');

--INSERT specifickych rysu dane rasy--
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R1', 'S5');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R2', 'S1');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R3', 'S4');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R4', 'S2');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R5', 'S3');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R6', 'S6');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R7', 'S7');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R8', 'S8');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R10', 'S9');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R9', 'S10');

--INSERT jakou rasu dany hostitel preferuje--
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H1', 'R1');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H2', 'R4');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H3', 'R2');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H4', 'R1');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H5', 'R5');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H6', 'R4');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H7', 'R2');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H8', 'R3');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H9', 'R8');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H10', 'R10');

--INSERT data o aktualnim zivote kocky--
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z2', 'T1');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z3', 'T3');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z4', 'T4');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z7', 'T2');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z11', 'T6');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z12', 'T6');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z14', 'T7');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z15', 'T9');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z17', 'T10');

--INSERT data o minulem zivote kocky--
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z1', 'prejeta autem' , 'T4');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z5', 'Utopena v zachodu.' ,'T5');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z6', 'Rozmacknuta padem houpacky' ,'T3');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z9', 'corona virus' ,'T5');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z10', 'pad ze strechy' ,'T3');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z13', 'umrela na hlad', 'T8');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z16', 'smrt leknutim' ,'T9');

---------------------------------------------------------- SELECT ------------------------------------------------------
--SQL skript obsahující dotazy SELECT musí obsahovat:
--  1. konkrétně alespoň dva dotazy využívající spojení dvou tabulek,
    -- Vypis vsech kocek a jejich typu rasy
        SELECT  Kocka.hlavni_jmeno as JMENO_KOCKY, Kocka.ID_rasy as ID_RASY, Rasa.typ as ZEME_PUVODU
        FROM Kocka JOIN Rasa ON Kocka.ID_rasy = Rasa.ID_rasy
        ORDER BY Kocka.ID_rasy;

    -- Vypis hostilete a jeho preference dane rasy
        SELECT Hostitel.jmeno as JMENO_HOSTITELE, Hostitel.ID_hostitel as ID_HOSTITELE, Rasa.typ as TYP_RASY
        FROM Preference JOIN Hostitel ON Preference.ID_hostitele = Hostitel.ID_hostitel
                        JOIN Rasa ON Preference.ID_rasy = Rasa.ID_rasy
        ORDER BY Hostitel.ID_hostitel;

--  2. jeden využívající spojení tří tabulek,
    -- Kocka kde je uvedeno jeji jmeno, jakeho typu rasy je a dale specificke rysy dane rasy, jakoz to barva oci, maximalni delka tesatku a puvod
        SELECT Kocka.hlavni_jmeno as JMENO_KOCKY, Rasa.typ as TYP_RASY, Specificke_rysy.barva_oci as SPECIFICKE_RYSY_BARVA_OCI, Specificke_rysy.max_delka_tesaku as SPECIFICKE_RYSY_DELKA_TESAKU, Specificke_rysy.puvod as SPECIFICKE_RYSY_PUVOD
        FROM Rysy_rasy JOIN Specificke_rysy ON Specificke_rysy.ID_rysy = Rysy_rasy.ID_rysy
                       JOIN Rasa ON Rasa.ID_rasy = Rysy_rasy.ID_rasy
                       JOIN Kocka on Rasa.ID_rasy = Kocka.ID_rasy
        ORDER BY Kocka.hlavni_jmeno;

--  3. dva dotazy s klauzulí GROUP BY a agregační funkcí,
    --Dotaz na jmeno kocky a v kolikatem zivote se nachazi
        SELECT Zivot.jmeno_kocky as JMENO_KOCKY, COUNT(*) as V_KOLIKATEM_ZIVOTE_SE_KOCKA_NACHAZI
        FROM Zivot
        GROUP BY Zivot.jmeno_kocky;

    --Dotaz na Typ Teritorium, pocet kocek ktere v danem teritoriu zily a delka nejdelsiho pobytu kocky v danem teritoriu
        SELECT Teritorium.typ_teritoria as TYP_TERITORIA, COUNT(Pohyb_kocky.ID_teritoria) as KOLIK_KOCEK_ZDE_ZILO, MAX(Pohyb_kocky.interval_pobytu) as NEJDELSI_DELKA_POBYTU_KOCKY
        FROM Pohyb_kocky JOIN Teritorium ON Pohyb_kocky.ID_teritoria = Teritorium.ID_teritorium
        GROUP BY Teritorium.typ_teritoria;

--  4. jeden dotaz obsahující predikát EXISTS
    --Dotaz ktery vypise v jakych teritoriich se vyskytovala vice jak 1 kocka
        SELECT Teritorium.ID_teritorium as ID_TERITORIA, Teritorium.typ_teritoria as TYP_TERITORIA
        FROM Teritorium
        WHERE EXISTS(
            SELECT COUNT(Pohyb_kocky.ID_teritoria)
            FROM Pohyb_kocky
            WHERE Pohyb_kocky.ID_teritoria = Teritorium.ID_teritorium
            GROUP BY Teritorium.typ_teritoria
            HAVING COUNT(Pohyb_kocky.ID_teritoria) > 1
            )
        ORDER BY Teritorium.typ_teritoria;

--  5. a jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat).
    --Dotaz ktery vypise Kocky, ktere se alespon jednou ze svych prozitych zivotu nedozily 1 roku, nebo kocky ktere ziji prvni zivot a nedozili se zatim 1 roku
        SELECT Kocka.hlavni_jmeno as JMENO_KOCKY, Kocka.barva_srsti as BARVA_SRSTI, Kocka.vzorek_kuze as VZOREK_KUZE
        FROM Kocka
        WHERE Kocka.hlavni_jmeno IN (
            SELECT Zivot.jmeno_kocky
            FROM Zivot
            WHERE Zivot.delka < 365
            );
--  - U každého z dotazů musí být (v komentáři SQL kódu) popsáno srozumitelně, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).

---------------------------------------------------------- TRIGERRY ------------------------------------------------------

-- Trigger na vytvoreni ID pro tabulku rasa
CREATE SEQUENCE rasa_pk_seq
  START WITH 790
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER rasa_next_id
    BEFORE INSERT
    ON Rasa
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_Rasy  IS NULL THEN
        :NEW.ID_Rasy := 'R'|| rasa_pk_seq.nextval;
    END IF;
END;
/
