#konta logowania
INSERT INTO `kontaLogowania` (`id`, `login`, `sha256Haslo`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3'),
(2, 'client', '62608e08adc29a8d6dbc9754e659f125'),
(3, 'personnel', 'f82366a9ddc064585d54e3f78bde3221'),
(4, 'personnel2', 'f82366a9ddc064585d54e3f78bde3221');

#adresy
INSERT INTO `adresy`(`id`, `miasto`, `wojewodztwo`, `kodPocztowy`, `ulica`, `nrDomu`, `nrLokalu`) VALUES
(1, 'Wałbrzych', 'dolnośląskie', '90-901', 'al. Szkolna', '2', NULL),
(2, 'Kielce', 'świętokrzyskie', '09-999', 'pl. Jednokierunkowa', '11', '4'),
(3, 'Zielona Góra', 'lubuskie', '19-999', 'ul. Magazynowa', '6a', '2'),
(4, 'Zielona Góra', 'lubuskie', '19-000', 'ul. Magazynowa', '182', '2');

#kontakty
INSERT INTO `kontakty`(`id`, `telefon1`, `telefon2`, `email`) VALUES
(1, '38294038290', '7328432789', 'klient@k.p'),
(2, '849305438950', '7328432789', 'personnel@p.p'),
(3, '3829403843290', NULL, 'kierownik@k.p');

#klienci
INSERT INTO `klienci`(`id`, `Imie`, `Nazwisko`, `idKontoLogowania`, `idAdres`, `idKontakt`, `nip`) VALUES
(1, 'Jan', 'Wąski', 2, 1, 1, '789789798789789');

#magazyny
INSERT INTO `magazyny`(`id`, `idAdres`) VALUES (1,3);

#personel
INSERT INTO `personel`(`id`, `Imie`, `Nazwisko`, `idKontoLogowania`, `idAdres`, `idKontakt`, `idMagazyn`, `kierownik`) VALUES
(1, 'Zygfryd', "Mariacki", 3, 2, 2, 1, 0),
(2, 'Aleksandra', "Drwal", 4, 3, 3, 1, 1);

#producenci
INSERT INTO `producenci`(`id`, `nazwaProducenta`) VALUES
(1, 'WIERTEX'),
(2, 'WINDPOL'),
(3, 'ZIMBABWE CONTINENTAL');

#kategorie
INSERT INTO `kategorie`(`id`, `nazwaKategorii`) VALUES
(1, 'football'),
(2, 'tenis'),
(3, 'pływanie');

#produkty
INSERT INTO `produkty`(`id`, `nazwa`, `idProducenta`, `idKategorii`, `opis`, `cenaNetto`, `cenaBrutto`) VALUES
(1, 'piłka zielona', 1, 1, 'piłka, zielona, okrągła, do footbolu', 0.10, 0.90),
(2, 'piłka czerwona', 1, 1, 'piłka, czerwona, okrągła, do footbolu', 0.80, 1.70),
(3, 'piłka niebieska', 2, 1, 'piłka, niebieska, okrągła, do footbolu', 105.90, 180.4),
(4, 'rakieta', 3, 2, 'czarna, z grafenu', 72.0, 102.86),
(5, 'siatka', 3, 2, '100m, nylonowa, biała', 7.20, 12.86);

#zaopatrzenie
INSERT INTO `zaopatrzenie`(`id`, `idProduktu`, `idMagazynu`, `ilosc`) VALUES
(1, 1, 1, 100000),
(2, 1, 1, 10),
(3, 2, 1, 10),
(4, 3, 1, 15),
(5, 4, 1, 1);
