#konta logowania
INSERT INTO `kontaLogowania` (`id`, `login`, `sha256Haslo`, `ostatnieLogowanie`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3', NULL),
(2, 'client', '62608e08adc29a8d6dbc9754e659f125', NULL),
(3, 'personnel', 'f82366a9ddc064585d54e3f78bde3221', NULL);

#adresy
INSERT INTO `adresy`(`id`, `miasto`, `wojewodztwo`, `kodPocztowy`, `ulica`, `nrDomu`, `nrLokalu`) VALUES
(1, 'Wałbrzych', 'dolnośląskie', '90-901', 'al. Szkolna', '2', NULL),
(2, 'Kielce', 'świętokrzyskie', '09-999', 'pl. Jednokierunkowa', '11', '4'),
(3, 'Zielona Góra', 'lubuskie', '19-999', 'ul. Magazynowa', '6a', '2');

#kontakty
INSERT INTO `kontakty`(`id`, `telefon1`, `telefon2`, `email`) VALUES
(1, '38294038290', '7328432789', 'klient@k.p'),
(2, '849305438950', '7328432789', 'personnel@p.p'),
(3, '3829403843290', NULL, 'kierownik@k.p');

#klienci
INSERT INTO `klienci`(`id`, `Imie`, `Nazwisko`, `idKontoLogowania`, `idAdres`, `idKontakt`, `nip`) VALUES
(1, 'Jan', 'Wąski', 2, 1, 1, '789789798789789');
