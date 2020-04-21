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

 ALTER TABLE Zivot ADD CONSTRAINT check_ID_1 CHECK (REGEXP_LIKE(ID_zivot,'Z[0-9]{3}'));
 ALTER TABLE Teritorium ADD CONSTRAINT check_ID_2 CHECK (REGEXP_LIKE(ID_teritorium,'T[0-9]{3}'));
 ALTER TABLE Vlastnictvi ADD CONSTRAINT check_ID_3 CHECK (REGEXP_LIKE(ID_vlastnictvi,'V[0-9]{3}'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_ID_4 CHECK (REGEXP_LIKE(ID_hostitel,'H[0-9]{3}'));
 ALTER TABLE Rasa ADD CONSTRAINT check_ID_5 CHECK (REGEXP_LIKE(ID_rasy,'R[0-9]{3}'));
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_ID_6 CHECK (REGEXP_LIKE(ID_rysy,'S[0-9]{3}'));

 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_interval_pobytu CHECK (interval_pobytu > 0);

 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_interval_vlastnictvi CHECK (REGEXP_LIKE(doba, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));


-------------------------------------------------------INSERT-----------------------------------------------------------------------
--INSERT Rasy--
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R001', 'Birma');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R002', 'Siamska');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R125', 'Munchkin');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R457', 'Ragdoll');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R521', 'Sphynx');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R244', 'Toyger');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R123', 'Perska');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R777', 'RagaMuffin');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R624', 'Peterbald');
INSERT INTO Rasa (ID_rasy, typ) VALUES ('R410', 'Nebelung');

--INSERT Kocek--
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('julca','BLK', 'fialova', 'R001');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('packa','TW', 'cerna', 'R002');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('micka','SKYB', 'bila', 'R125');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('fous','BLK', 'cerna', 'R457');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('tlapka','YLW', 'oranzova', 'R521');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('max', 'BLK', 'zrzava', 'R244');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('richie', 'ZNK', 'seda', 'R624');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('silva', 'TW', 'zlatava', 'R777');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('pan zvon', 'BLK', 'cerna', 'R457');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('dextr', 'SKYB', 'seda', 'R123');

--INSERT Zivota dane kocky--
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z001', 1, '2555', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z003', 2, '465', 'julca');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z002', 1, '4895', 'packa');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z123', 1, '25', 'micka');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z222', 1, '1', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z223', 2, '745', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z246', 3, '365', 'fous');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z564', 1, '1698', 'tlapka');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z101', 1, '156', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z102', 2, '3120', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z103', 3, '3', 'max');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z104', 1, '999', 'richie');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z105', 1, '2222', 'silva');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z106', 2, '887', 'silva');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z107', 1, '1655', 'pan zvon');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z187', 1, '3522', 'dextr');
INSERT INTO Zivot (ID_zivot, poradi, delka, jmeno_kocky) VALUES ('Z197', 2, '1111', 'dextr');

--INSERT Teritorii--
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T001', 'obyvak', 20);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T002', 'kuchyn', 10);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T156', 'zahrada', 50);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T546', 'ulice', 200);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T991', 'toaleta', 3);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T003', 'garaz', 45);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T103', 'sklep', 30);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T111', 'puda', 70);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T420', 'predsin', 10);
INSERT INTO Teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T177', 'koupelna', 15);

--INSERT Hostitelu--
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H001', 'Pavel', 42, 'muz', 'Znojmo');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H002', 'Marek', 22, 'muz', 'Brno');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H055', 'Boris', 21, 'muz', 'Praha');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H150', 'Dan', 21, 'muz', 'Ostrava');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H854', 'Jan', 22, 'muz', 'Plzen');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H855', 'Katka', 56, 'zena', 'Most');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H954', 'Monika', 17, 'zena', 'Jundrov');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H958', 'Rebeka', 32, 'zena', 'Hradec Kralove');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H003', 'Lukas', 45, 'muz', 'LA');
INSERT INTO Hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H333', 'Michaela', 77, 'zena', 'Zlin');

--INSERT typu vlastnictvi--
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V001', 'balonek', 3, 'H001', 'julca', 'T001');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V002', 'klubicko bavlny', 2, '', 'julca', 'T001');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V269', 'letajici talir', 1, 'H150', 'micka', 'T991');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V400', 'bumerang', 1, 'H854', 'tlapka', 'T156');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V562', 'klacik', 12, '', '', 'T002');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V003', 'drazditko', 10, '', '', 'T111');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V004', 'plysova rybicka', 3, 'H003', 'richie', 'T420');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V298', 'myska', 4, 'H954', 'max', 'T111');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V300', 'polstarek', 1, '', '', 'T001');
INSERT INTO Vlastnictvi (ID_vlastnictvi, typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('V444', 'pirko na tycince', 4, 'H855', 'pan zvon', 'T103');

--INSERT specifickych rysu--
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S001', 'zelena', 'Egypt', '27cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S002', 'modra', 'Cesko', '12cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S247', 'hneda', 'Cina', '15cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S542', 'cervena', 'Nemecko', '7cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S734', 'cerna', 'Italie', '6cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S665', 'duhova', 'Izrael', '2cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S003', 'modro zelena', 'Pakistan', '9cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S132', 'zeleno hneda', 'Egypt', '11cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S004', 'tmave hneda', 'California', '4cm');
INSERT INTO Specificke_rysy (ID_rysy, barva_oci, puvod, max_delka_tesaku) VALUES ('S007', 'svetle modra', 'Indie', '3cm');

--INSERT pohybu kocky--
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK001', '324', 'packa', 'T001');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK011', '480', 'packa', 'T001');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK002', '54', 'julca', 'T001');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK003', '178', 'micka', 'T002');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK004', '544', 'fous', 'T991');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK014', '200', 'fous', 'T991');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK005', '724', 'tlapka', 'T156');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK006', '10', 'max', 'T177');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK007', '684', 'silva', 'T103');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK008', '100', 'richie', 'T003');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK009', '178', 'silva', 'T111');
INSERT INTO Pohyb_kocky (ID_pohyb_kocky, interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('PK010', '29', 'dextr', 'T420');

--INSERT intervalu vlastnictvi--
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV001', '324d', 'julca', 'V001');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV002', '54d', 'julca', 'V002');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV003', '1r25d', 'micka', 'V269');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV004', '2d', 'tlapka', 'V400');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV005', '15d', 'max', 'V300');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV006', '1d', 'silva', 'V444');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV007', '39d', 'pan zvon', 'V298');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV008', '2d', 'max', 'V004');
INSERT INTO Interval_vlastnictvi (ID_interval_vlastnictvi, doba, jmeno_kocky, ID_vlastnictvi) VALUES ('IV009', '3r2d', 'dextr', 'V298');

--INSERT jaky hostitel slouzi jake kocce--
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL001', 'kulisak', 'julca', 'H001');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL002', 'zrout', 'packa', 'H001');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL003', 'otrava', 'micka', 'H002');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL004', 'kulicka', 'fous', 'H954');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL005', 'milacek', 'tlapka', 'H854');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL006', 'slinta', 'max', 'H855');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL007', 'lizal', 'dextr', 'H333');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL008', 'fantom', 'silva', 'H003');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL009', 'zrout', 'richie', 'H150');
INSERT INTO Slouzi (ID_slouzi, prezdivka, jmeno_kocky, ID_hostitele) VALUES ('SL010', 'lenoch', 'pan zvon', 'H055');

--INSERT specifickych rysu dane rasy--
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R001', 'S734');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R002', 'S001');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R125', 'S542');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R457', 'S002');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R521', 'S247');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R244', 'S665');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R123', 'S003');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R777', 'S132');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R410', 'S004');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R624', 'S007');

--INSERT jakou rasu dany hostitel preferuje--
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H001', 'R001');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H002', 'R457');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H055', 'R002');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H150', 'R001');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H854', 'R521');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H855', 'R457');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H954', 'R002');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H958', 'R125');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H003', 'R777');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H333', 'R410');

--INSERT data o aktualnim zivote kocky--
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z003', 'T001');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z002', 'T156');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z123', 'T546');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z246', 'T002');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z103', 'T003');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z104', 'T003');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z106', 'T103');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z107', 'T420');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z197', 'T177');

--INSERT data o minulem zivote kocky--
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z001', 'prejeta autem' , 'T546');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z222', 'Utopena v zachodu.' ,'T991');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z223', 'Rozmacknuta padem houpacky' ,'T156');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z101', 'corona virus' ,'T991');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z102', 'pad ze strechy' ,'T156');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z105', 'umrela na hlad', 'T111');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z187', 'smrt leknutim' ,'T420');

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
