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

--- Tvorba tabulek
CREATE TABLE Kocka
        (
            hlavni_jmeno VARCHAR(160) NOT NULL PRIMARY KEY,
            vzorek_kuze INT NOT NULL,
            barva_srsti VARCHAR(50) NOT NULL,

            typ_rasy VARCHAR(50) NOT NULL --FK rasy
        );

CREATE TABLE Zivot
        (
            ID_zivot INT NOT NULL PRIMARY KEY, -- regex na max 9
            poradi INT NOT NULL,
            delka INT NOT NULL,

            ID_kocky VARCHAR(160) NOT NULL -- FK kocky
        );

CREATE TABLE Teritorium
        (
            ID_teritorium VARCHAR(50) NOT NULL PRIMARY KEY,
            typ_teritoria VARCHAR(50) NOT NULL,
            kapacita_kocek INT NOT NULL
        );

CREATE TABLE Vlastnictvi
        (
            ID_valstnictvi VARCHAR(50) NOT NULL PRIMARY KEY,
            typ_vlastnictvi VARCHAR(50) NOT NULL,
            kvantita INT NOT NULL,

            ID_hostitele VARCHAR(50), -- FK hostitele
            ID_kocky VARCHAR(160), -- FK kocky
            ID_teritoria VARCHAR(50) NOT NULL -- FK teritoria
        );

CREATE TABLE Hostitel
        (
            ID_hostitel VARCHAR(50) NOT NULL PRIMARY KEY,
            jmeno VARCHAR(50) NOT NULL,
            vek INT NOT NULL,
            pohlavi INT(1),   -- Oracle nema bolean nakze napr Muž - 1, Žena - 0
            misto_bydleni VARCHAR(50) NOT NULL
        );

CREATE TABLE Rasa
        (
            ID_typ VARCHAR(50) NOT NULL PRIMARY KEY,
            puvpd VARCHAR(50) NOT NULL,
            max_delka_tesaku INT NOT NULL
        );

CREATE TABLE Specificke_rysy
        (
            ID_rysy VARCHAR(50) NOT NULL PRIMARY KEY,
            barva_oci VARCHAR(50) NOT NULL
        );


-- TABULKY M:N VAZEB --

CREATE TABLE Pohyb_kocky
        (
            interval_pobytu VARCHAR(10) NOT NULL PRIMARY KEY, -- TIME????????

            ID_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            ID_teritoria VARCHAR(50) NOT NULL ON DELETE CASCADE --Fk teritoria
        );

CREATE TABLE Interval_vlastnictvi
        (
            doba VARCHAR(10) NOT NULL PRIMARY KEY,

            ID_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            ID_vlastnictvi VARCHAR(50) NOT NULL ON DELETE CASCADE --FK vlastnictvi
        );

CREATE TABLE Slouzi
        (
            prezdivka VARCHAR(50) NOT NULL PRIMARY KEY,

            ID_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            ID_hostitele VARCHAR(50) NOT NULL ON DELETE CASCADE--FK hostitel
        );

CREATE TABLE Rysy_rasy
        (
            ID_rasy VARCHAR(50) NOT NULL ON DELETE CASCADE, -- FK rasy
            ID_rysy VARCHAR(50) NOT NULL ON DELETE CASCADE -- FK
        );

CREATE TABLE Preference
        (
            ID_hostitele VARCHAR(50) NOT NULL ON DELETE CASCADE, -- FK hostitele
            ID_rasy VARCHAR(50) NOT NULL ON DELETE CASCADE -- FK rasy
        );

-- GENERALIZACE/SPECIALIZACE --
CREATE TABLE Minuly
        (
            ID_zivot INT NOT NULL, --FK zivot

            zpusob_smrti VARCHAR(100) NOT NULL,
            misto_narozeni VARCHAR(50) NOT NULL
        );

CREATE TABLE Aktualni
        (
            ID_zivot INT NOT NULL, -- FK zivot

            misto_narozeni VARCHAR(50) NOT NULL
        );

------- FK ------
-- kocky --
    ALTER TABLE Kocka ADD CONSTRAINT fk_je_rasy FOREIGN KEY (typ_rasy) REFERENCES Rasa;
-- zivot --
    ALTER TABLE Zivot ADD CONSTRAINT fk_ma_kocku FOREIGN KEY (id_kocky) REFERENCES Kocka;
-- vlastnictvi --
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_je_propujceno FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_ma FOREIGN KEY (ID_kocky) REFERENCES Kocka;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_se_nachazi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
-- M:N vazby --
--pohyb_kocky--
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_se_pohybuje FOREIGN KEY (ID_kocky) REFERENCES Kocky;
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_v_prostredi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
--interval_vlastnictvi--
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_je_vlastneno FOREIGN KEY (ID_kocky) REFERENCES Kocka;
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_je_propujceno FOREIGN KEY (ID_vlastnictvi) REFERENCES Vlastnictvi;
--slouzi--
    ALTER TABLE Slouzi ADD CONSTRAINT fk_slouzi FOREIGN KEY (ID_kocky) REFERENCES Kocka;
    ALTER TABLE Slouzi ADD CONSTRAINT fk_je_panem FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
--rysy_rasy--
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_rasa_ma FOREIGN KEY (ID_rasy) REFERENCES Rasa;
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_jsou FOREIGN KEY (ID_rysy) REFERENCES Specificke_rysy;
--preference--
    ALTER TABLE Preference ADD CONSTRAINT fk_hostitel FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Preference ADD CONSTRAINT fk_preferuje FOREIGN KEY (ID_rasy) REFERENCES Rasa;
-- Minuly --
    ALTER TABLE Minuly ADD CONSTRAINT fk_zil FOREIGN KEY (ID_zivot) REFERENCES Zivot;
-- Aktualni --
    ALTER TABLE Aktualni ADD CONSTRAINT fk_zije FOREIGN KEY (ID_zivot) REFERENCES Zivot;




















    --- Vsechny ID_neco upravit Varchar na 4!
 INSERT INTO kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, typ_rasy) VALUES ('julca','BLK', 'fialova', 'Birma'); -- zmenit vzorek_kuze na VARCHAR
 INSERT INTO zivot (ID_zivot, poradi, delka) VALUES ('Z123', '1', '13r254d'); -- regex na rok a dny
 INSERT INTO teritorium (ID_teritorium, typ_teritoria, kapacita_kocek) VALUES ('T991', 'obyvacka', '20');
 INSERT INTO vlastnictvi (ID_valstnictvi, typ_vlastnictvi, kvantita) VALUES ('V845', 'balonek', '3');
 INSERT INTO hostitel (ID_hostitel, jmeno, vek, pohlavi, misto_bydleni) VALUES ('H005', 'Pavel', '25', '1', 'Znojmo'); -- check na pohlavi, check na vek
 INSERT INTO rasa (ID_typ, puvpd, max_delka_tesaku) VALUES ('R478', 'Egypt', '27'); -- opravit puvpd, regex na cm?
 INSERT INTO specificke_rysy (ID_rysy, barva_oci) VALUES ('S247', 'zelena');