-- CreateTable
CREATE TABLE "Filiale" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "adresse" TEXT
);

-- CreateTable
CREATE TABLE "Abteilung" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "filialeId" INTEGER NOT NULL,
    CONSTRAINT "Abteilung_filialeId_fkey" FOREIGN KEY ("filialeId") REFERENCES "Filiale" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Mitarbeiter" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "vorname" TEXT NOT NULL,
    "nachname" TEXT NOT NULL,
    "filialeId" INTEGER NOT NULL,
    CONSTRAINT "Mitarbeiter_filialeId_fkey" FOREIGN KEY ("filialeId") REFERENCES "Filiale" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Buch" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "titel" TEXT NOT NULL,
    "autor" TEXT,
    "isbn" TEXT,
    "abteilungId" INTEGER NOT NULL,
    CONSTRAINT "Buch_abteilungId_fkey" FOREIGN KEY ("abteilungId") REFERENCES "Abteilung" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Exemplar" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "barcode" TEXT,
    "zustand" TEXT,
    "filialeId" INTEGER NOT NULL,
    "buchId" INTEGER NOT NULL,
    CONSTRAINT "Exemplar_filialeId_fkey" FOREIGN KEY ("filialeId") REFERENCES "Filiale" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Exemplar_buchId_fkey" FOREIGN KEY ("buchId") REFERENCES "Buch" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Kunde" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "vorname" TEXT NOT NULL,
    "nachname" TEXT NOT NULL,
    "email" TEXT
);

-- CreateTable
CREATE TABLE "Entlehnung" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "exemplarId" INTEGER NOT NULL,
    "kundeId" INTEGER NOT NULL,
    "mitarbeiterId" INTEGER NOT NULL,
    "entliehenAm" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "retourDatum" DATETIME,
    "returned" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "Entlehnung_exemplarId_fkey" FOREIGN KEY ("exemplarId") REFERENCES "Exemplar" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Entlehnung_kundeId_fkey" FOREIGN KEY ("kundeId") REFERENCES "Kunde" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Entlehnung_mitarbeiterId_fkey" FOREIGN KEY ("mitarbeiterId") REFERENCES "Mitarbeiter" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Buch_isbn_key" ON "Buch"("isbn");

-- CreateIndex
CREATE UNIQUE INDEX "Exemplar_barcode_key" ON "Exemplar"("barcode");

-- CreateIndex
CREATE UNIQUE INDEX "Kunde_email_key" ON "Kunde"("email");
