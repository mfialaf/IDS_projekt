CREATE TABLE kocka
          (
              hlavni_jmeno VARCHAR(160) NOT NULL PRIMARY KEY,
              vzorek_kuze INT NOT NULL,
              barva_srsti VARCHAR(50) NOT NULL
          );

CREATE TABLE zivot
          (
              ID_zivot INT NOT NULL PRIMARY KEY, -- regex na max 9
              poradi INT NOT NULL,
              delka INT NOT NULL,
              misto_narozeni VARCHAR(50) NOT NULL
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
              kvantita INT NOT NULL
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

--- TABULKY VAZEB ---------

CREATE TABLE interval_pobytu
          (
              doba TIME NOT NULL PRIMARY KEY
          );

CREATE TABLE interval_vlastnictvi
          (
              doba TIME NOT NULL PRIMARY KEY
          );

CREATE TABLE nazyva
          (
              prezdivka VARCHAR(50) NOT NULL PRIMARY KEY
          )
