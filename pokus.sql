--- Smazani objektu pro novy start
  DROP TABLE kocka        CASCADE CONSTRAINTS;
  DROP TABLE zivot     CASCADE CONSTRAINTS;
  DROP TABLE teritorium          CASCADE CONSTRAINTS;
  DROP TABLE vlastnictvi          CASCADE CONSTRAINTS;
  DROP TABLE hostitel        CASCADE CONSTRAINTS;
  DROP TABLE rasa         CASCADE CONSTRAINTS;
  DROP TABLE specificke_rysy         CASCADE CONSTRAINTS;
  DROP TABLE interval_pobytu       CASCADE CONSTRAINTS;
  DROP TABLE interval_vlastnictvi   CASCADE CONSTRAINTS;
  DROP TABLE nazyva   CASCADE CONSTRAINTS;

--- Tvorba tabulek
CREATE TABLE kocka
        (
            hlavni_jmeno VARCHAR(160) NOT NULL PRIMARY KEY,
            vzorek_kuze INT NOT NULL,
            barva_srsti VARCHAR(50) NOT NULL,

            typ_rasy VARCHAR(50) NOT NULL --FK rasy
        );

CREATE TABLE zivot
        (
            ID_zivot INT NOT NULL PRIMARY KEY, -- regex na max 9
            poradi INT NOT NULL,
            delka INT NOT NULL,

            id_kocky VARCHAR(160) NOT NULL -- FK kocky
        );

CREATE TABLE teritorium
        (
            ID_teritorium VARCHAR(50) NOT NULL PRIMARY KEY,
            typ_teritoria VARCHAR(50) NOT NULL,
            kapacita_kocek INT NOT NULL
        );

CREATE TABLE vlastnictvi
        (
            ID_valstnictvi VARCHAR(50) NOT NULL PRIMARY KEY,
            typ_vlastnictvi VARCHAR(50) NOT NULL,
            kvantita INT NOT NULL,

            id_hostitele VARCHAR(50), -- FK hostitele
            id_teritoria VARCHAR(50) NOT NULL -- FK teritoria
        );

CREATE TABLE hostitel
        (
            ID_hostitel VARCHAR(50) NOT NULL PRIMARY KEY,
            jmeno VARCHAR(50) NOT NULL,
            vek INT NOT NULL,
            pohlavi INT(1),   -- Oracle nema bolean nakze napr Muž - 1, Žena - 0
            misto_bydleni VARCHAR(50) NOT NULL
        );

CREATE TABLE rasa
        (
            ID_typ VARCHAR(50) NOT NULL PRIMARY KEY,
            puvpd VARCHAR(50) NOT NULL,
            max_delka_tesaku INT NOT NULL
        );

CREATE TABLE specificke_rysy
        (
            ID_rysy VARCHAR(50) NOT NULL PRIMARY KEY,
            barva_oci VARCHAR(50) NOT NULL
        );


-- TABULKY M:N VAZEB --

CREATE TABLE pohyb_kocky
        (
            interval_pobytu VARCHAR(10) NOT NULL PRIMARY KEY, -- TIME????????

            id_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            id_teritoria VARCHAR(50) NOT NULL ON DELETE CASCADE --Fk teritoria
        )

CREATE TABLE interval_vlastnictvi
        (
            doba VARCHAR(10) NOT NULL PRIMARY KEY,

            id_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            id_vlastnictvi VARCHAR(50) NOT NULL ON DELETE CASCADE --FK vlastnictvi
        );

CREATE TABLE slouzi
        (
            prezdivka VARCHAR(50) NOT NULL PRIMARY KEY,

            id_kocky VARCHAR(160) NOT NULL ON DELETE CASCADE, --FK kocky
            id_hostitele VARCHAR(50) NOT NULL ON DELETE CASCADE--FK hostitel
        );

CREATE TABLE rysy_rasy
        (
            id_rasy VARCHAR(50) NOT NULL ON DELETE CASCADE, -- FK rasy
            id_rysy VARCHAR(50) NOT NULL ON DELETE CASCADE -- FK
        );

CREATE TABLE preference
        (
            id_hostitele VARCHAR(50) NOT NULL ON DELETE CASCADE, -- FK hostitele
            id_rasy VARCHAR(50) NOT NULL ON DELETE CASCADE -- FK rasy
        )


---
 ALTER TABLE kocka ADD CONSTRAINT fk_je_rasy FOREIGN KEY (typ_rasy) REFERENCES rasa;