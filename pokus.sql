CREATE TABLE kočka
          (
              hlavní_jméno VARCHAR(160) NOT NULL PRIMARY KEY,
              vzorek_kůže INT NOT NULL,
              barva_srsti VARCHAR(50) NOT NULL
          )

CREATE TABLE život
          (
              ID_život INT NOT NULL PRIMARY KEY, -- regex na max 9
              pořadí INT NOT NULL,
              délka INTERVAL NOT NULL,
              místo_narození VARCHAR(50) NOT NULL
          )

CREATE TABLE teritorium
          (
              ID_teritorium VARCHAR(50) NOT NULL PRIMARY KEY,
              typ_teritoria VARCHAR(50) NOT NULL,
              kapacita_koček INT NOT NULL,
          )

CREATE TABLE vlastnictví
          (
              ID_valstnictví VARCHAR(50) NOT NULL PRIMARY KEY,
              typ_vlastnictví VARCHAR(50) NOT NULL,
              kvantita INT NOT NULL,
          )

CREATE TABLE hostitel
          (
              ID_hostitel VARCHAR(50) NOT NULL PRIMARY KEY,
              jméno VARCHAR(50) NOT NULL,
              věk INT NOT NULL,
              pohlaví INT(1),   -- Oracle nema bolean nakze napr Muž - 1, Žena - 0
              místo_bydlení VARCHAR(50) NOT NULL,
          )

CREATE TABLE rasa
          (
              ID_typ VARCHAR(50) NOT NULL PRIMARY KEY,
              půvpd VARCHAR(50) NOT NULL,
              max_délka_tesáků INT NOT NULL,
          )

CREATE TABLE specifické_rysy
          (
              ID_rysy VARCHAR(50) NOT NULL PRIMARY KEY,
              barva_očí VARCHAR(50) NOT NULL,
          )

--- TABULKY VAZEB ---------

CREATE TABLE interval_pobytu
          (
              doba TIME NOT NULL PRIMARY KEY
          )

CREATE TABLE interval_vlastnictví
          (
              doba TIME NOT NULL PRIMARY KEY
          )

CREATE TABLE nazývá
          (
              přezdívka VARCHAR(50) NOT NULL PRIMARY KEY
          )
