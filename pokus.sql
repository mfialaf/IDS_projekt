CREATE TABLE "Hráč"
          (
              "id" INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
              "jméno" VARCHAR(160) NOT NULL,
              "věk" INT NOT NULL
          )