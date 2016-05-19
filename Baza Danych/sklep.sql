SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema sklepbd
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sklepbd` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `sklepbd` ;

-- -----------------------------------------------------
-- Table `sklepbd`.`kontaLogowania`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`kontaLogowania` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `sha256Haslo` VARCHAR(45) NOT NULL,
  `ostatnieLogowanie` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`adresy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`adresy` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `miasto` VARCHAR(45) NOT NULL,
  `wojewodztwo` VARCHAR(45) NULL,
  `kodPocztowy` VARCHAR(45) NOT NULL,
  `ulica` VARCHAR(45) NOT NULL,
  `nrDomu` VARCHAR(45) NOT NULL,
  `nrLokalu` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`kontakty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`kontakty` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `telefon1` VARCHAR(45) NOT NULL,
  `telefon2` VARCHAR(45) NULL,
  `fax` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`klienci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`klienci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `idKontoLogowania` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  `idKontakt` INT UNSIGNED NOT NULL,
  `nip` VARCHAR(45) NULL,
  `dataDodania` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `index1` (`idKontoLogowania` ASC),
  INDEX `index2` (`idAdres` ASC),
  INDEX `index3` (`idKontakt` ASC),
  CONSTRAINT `fk_klienci_1`
    FOREIGN KEY (`idKontoLogowania`)
    REFERENCES `sklepbd`.`kontaLogowania` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_klienci_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_klienci_3`
    FOREIGN KEY (`idKontakt`)
    REFERENCES `sklepbd`.`kontakty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`magazyny`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`magazyny` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idAdres` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `index3` (`idAdres` ASC),
  CONSTRAINT `fk_sklepy_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`personel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`personel` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `idKontoLogowania` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  `idKontakt` INT UNSIGNED NOT NULL,
  `idMagazyn` INT UNSIGNED NOT NULL,
  `kierownik` INT(1) NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `index2` (`idKontoLogowania` ASC),
  INDEX `index3` (`idAdres` ASC),
  INDEX `index4` (`idKontakt` ASC),
  INDEX `index5` (`idMagazyn` ASC),
  CONSTRAINT `fk_personel_1`
    FOREIGN KEY (`idKontoLogowania`)
    REFERENCES `sklepbd`.`kontaLogowania` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_3`
    FOREIGN KEY (`idKontakt`)
    REFERENCES `sklepbd`.`kontakty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_4`
    FOREIGN KEY (`idMagazyn`)
    REFERENCES `sklepbd`.`magazyny` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`producenci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`producenci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwaProducenta` VARCHAR(45) NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`kategorie` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwaKategorii` VARCHAR(45) NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`produkty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`produkty` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwa` VARCHAR(45) NOT NULL,
  `idProducenta` INT UNSIGNED NOT NULL,
  `idKategorii` INT UNSIGNED NOT NULL,
  `opis` TEXT NULL,
  `cenaNetto` DECIMAL(10,2) NOT NULL,
  `cenaBrutto` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `index2` (`idProducenta` ASC),
  INDEX `index3` (`idKategorii` ASC),
  CONSTRAINT `fk_produkty_1`
    FOREIGN KEY (`idProducenta`)
    REFERENCES `sklepbd`.`producenci` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produkty_2`
    FOREIGN KEY (`idKategorii`)
    REFERENCES `sklepbd`.`kategorie` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`zaopatrzenie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`zaopatrzenie` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idProduktu` INT UNSIGNED NOT NULL,
  `idMagazynu` INT UNSIGNED NOT NULL,
  `ilosc` DECIMAL UNSIGNED NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `index2` (`idProduktu` ASC),
  INDEX `index3` (`idMagazynu` ASC),
  CONSTRAINT `fk_zaopatrzenie_1`
    FOREIGN KEY (`idProduktu`)
    REFERENCES `sklepbd`.`produkty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_zaopatrzenie_2`
    FOREIGN KEY (`idMagazynu`)
    REFERENCES `sklepbd`.`magazyny` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`sprzedaz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`sprzedaz` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idZaopatrzenia` INT UNSIGNED NOT NULL,
  `idKlienta` INT UNSIGNED NOT NULL,
  `idPracownika` INT UNSIGNED NOT NULL,
  `dataSprzeazy` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `index2` (`idZaopatrzenia` ASC),
  INDEX `index3` (`idKlienta` ASC),
  INDEX `index4` (`idPracownika` ASC),
  CONSTRAINT `fk_sprzedaz_1`
    FOREIGN KEY (`idZaopatrzenia`)
    REFERENCES `sklepbd`.`zaopatrzenie` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sprzedaz_2`
    FOREIGN KEY (`idKlienta`)
    REFERENCES `sklepbd`.`klienci` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sprzedaz_3`
    FOREIGN KEY (`idPracownika`)
    REFERENCES `sklepbd`.`personel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`platnosci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`platnosci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idKlienta` INT UNSIGNED NOT NULL,
  `idPracownika` INT UNSIGNED NOT NULL,
  `idSprzedazy` INT UNSIGNED NULL,
  `rodzaj` ENUM('karta','gotowka','przelew') NULL,
  `ilosc` DECIMAL NOT NULL,
  `dataPlatnosci` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `index2` (`idKlienta` ASC),
  INDEX `index3` (`idPracownika` ASC),
  INDEX `index4` (`idSprzedazy` ASC),
  CONSTRAINT `fk_platnosci_1`
    FOREIGN KEY (`idKlienta`)
    REFERENCES `sklepbd`.`klienci` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_platnosci_2`
    FOREIGN KEY (`idPracownika`)
    REFERENCES `sklepbd`.`personel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_platnosci_3`
    FOREIGN KEY (`idSprzedazy`)
    REFERENCES `sklepbd`.`sprzedaz` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

######WIDOKI
CREATE VIEW `lista_towarow` AS
  SELECT
        pdk.id idProduktu,
        zop.ilosc ilosc,
        pdk.nazwa,
        pdk.opis,
        pdk.cenaBrutto,
        pdc.nazwaProducenta
    FROM
        produkty pdk
    JOIN
        producenci pdc
    ON
        pdk.idProducenta = pdc.id
    LEFT JOIN
        zaopatrzenie zop
    ON
        zop.idProduktu = pdk.id;

#####DANE TESTOWE
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
(4, 'Zielona Góra', 'lubuskie', '19-000', 'ul. Magazynowa', '182', '2'),
(5, 'Zielona Góra', 'lubuskie', '19-000', 'ul. Portowa', '12', '2'),
(6, 'Białystok', 'podlaskie', '33-908', 'ul. Powstańców warszawskich', '1', NULL);

#kontakty
INSERT INTO `kontakty`(`id`, `telefon1`, `telefon2`, `email`) VALUES
(1, '38294038290', '7328432789', 'klient@k.p'),
(2, '849305438950', '7328432789', 'personnel@p.p'),
(3, '3829403843290', NULL, 'kierownik@k.p');

#klienci
INSERT INTO `klienci`(`id`, `Imie`, `Nazwisko`, `idKontoLogowania`, `idAdres`, `idKontakt`, `nip`) VALUES
(1, 'Jan', 'Wąski', 2, 1, 1, '789789798789789');

#magazyny
INSERT INTO `magazyny`(`id`, `idAdres`) VALUES
(1,3),
(2,5),
(3,6);

#personel
INSERT INTO `personel`(`id`, `Imie`, `Nazwisko`, `idKontoLogowania`, `idAdres`, `idKontakt`, `idMagazyn`, `kierownik`) VALUES
(1, 'Zygfryd', "Mariacki", 3, 2, 2, 1, 0),
(2, 'Aleksandra', "Drwal", 4, 3, 3, 1, 1);

#producenci
INSERT INTO `producenci`(`id`, `nazwaProducenta`) VALUES
(1, 'WIERTEX'),
(2, 'PRO ONE'),
(3, 'ZIMBABWE CONTINENTAL'),
(4, 'TRANSBARD'),
(5, 'MKPZ WISŁA'),
(6, 'DIO'),
(7, 'DEM BA DUR'),
(8, 'E104B'),
(9, 'EIGENWERT'),
(10, 'AEROPLANT'),
(11, 'WINDPOL'),
(12, 'WINDPOL CONTINENTAL');

#kategorie
INSERT INTO `kategorie`(`id`, `nazwaKategorii`) VALUES
(1, 'football'),
(2, 'tenis'),
(3, 'pływanie'),
(4, 'baseball'),
(5, 'wspinaczka');

#produkty
INSERT INTO `produkty`(`id`, `nazwa`, `idProducenta`, `idKategorii`, `opis`, `cenaNetto`, `cenaBrutto`) VALUES
(1, 'piłka zielona', 1, 1, 'piłka, zielona, okrągła, do footbolu', 0.10, 0.90),
(2, 'piłka czerwona', 1, 1, 'piłka, czerwona, okrągła, do footbolu', 0.80, 1.70),
(3, 'piłka niebieska', 2, 1, 'piłka, niebieska, okrągła, do footbolu', 105.90, 180.4),
(4, 'rakieta', 3, 2, 'czarna, z grafenu', 72.0, 102.86),
(5, 'siatka', 3, 2, '100m, nylonowa, biała', 7.20, 12.86),
(6, 'korki', 1, 1, 'czerwone, rozmiary: 30-50', 2.15, 3.15),
(7, 'lina', 5, 5, '25 m', 120.80, 121.70),
(8, 'lina', 6, 5, '25m', 105.90, 180.4),
(9, 'rakieta', 1, 2, 'czarna, z plastyku', 1.0, 2.86),
(10, 'kąpielówki męskie', 6, 3, '', 1.9, 2.96),
(11, 'kąpielówki chłopięce', 6, 3, '', 0.10, 0.90),
(12, 'strój kąpielowy', 6, 3, 'jednoczęściowy', 0.80, 1.70),
(13, 'strój kąpielowy', 6, 3, 'dwuczęściowy', 105.90, 180.4),
(14, 'zbierak', 3, 2, 'czarna, z grafenu', 21.0, 23.86),
(15, 'piłki do tenisa', 9, 2, 'żółte, 18 szt.', 6.5, 22.5),
(16, 'piłki do tenisa', 12, 2, 'zielone, 26 szt.', 8.0, 18.0),
(17, 'skarpety', 4, 1, 'wełniane, rozmiary: 15-50', 20.0, 21.70),
(18, 'gwizdek', 7, 1, '300 dB', 105.90, 180.4),
(19, 'rakieta', 3, 2, 'czarna, z grafenu', 72.0, 102.86),
(20, 'siatka', 3, 2, '100m, nylonowa, biała', 7.20, 12.86),
(21, 'kij baseballowy', 3, 4, 'żelazny', 80.10, 80.90),
(22, 'kij baseballowy', 3, 4, 'aluminiowy', 80.10, 80.90),
(23, 'czapka baseballówka', 2, 4, 'niebieska, czerwona, zielona', 0.90, 0.94),
(24, 'rękawice', 10, 1, 'białe, czarne', 20, 20.86),
(25, 'rękawice', 10, 1, 'żółte', 21, 21.86),
(26, 'kask', 5, 5, 'zielony, czerwony, żółty', 0.10, 0.90),
(27, 'czepek', 11, 3, '', 10, 15),
(28, 'czepek', 12, 3, '', 11.90, 12.4),
(29, 'piłki do baseballa', 9, 4, 'białe, 2 szt.', 62.0, 62.86),
(30, 'buty do tenisa', 9, 2, 'rozmiary: 12-17', 72.20, 122.86);

#zaopatrzenie
INSERT INTO `zaopatrzenie`(`id`, `idProduktu`, `idMagazynu`, `ilosc`) VALUES
(1, 1, 1, 100000),
(2, 1, 1, 12),
(3, 2, 1, 90),
(4, 3, 1, 15),
(5, 4, 1, 1),
(6, 6, 1, 100000),
(7, 6, 1, 10),
(8, 7, 1, 2),
(9, 8, 1, 12),
(10, 14, 1, 1),
(11, 9, 1, 100000),
(12, 12, 1, 5),
(13, 20, 1, 10),
(14, 10, 1, 6),
(15, 11, 1, 7),
(16, 12, 1, 14),
(17, 13, 1, 10),
(18, 24, 1, 10),
(19, 13, 1, 21),
(20, 15, 1, 43),
(21, 17, 1, 45),
(22, 1, 1, 2),
(23, 18, 1, 23),
(24, 19, 2, 15),
(25, 20, 2, 1),
(26, 12, 2, 234),
(27, 23, 2, 10),
(28, 24, 2, 10),
(29, 25, 2, 45),
(30, 26, 2, 1),
(31, 27, 2, 325),
(32, 28, 2, 10),
(33, 29, 2, 435),
(34, 30, 3, 15),
(35, 19, 3, 1),
(36, 25, 3, 15),
(37, 12, 3, 1),
(38, 13, 3, 3),
(39, 14, 3, 34),
(40, 15, 3, 10),
(41, 17, 3, 15),
(42, 8, 2, 1),
(43, 26, 3, 1),
(44, 27, 3, 34543),
(45, 28, 3, 3543),
(46, 29, 3, 34534),
(47, 30, 3, 34543),
(48, 19, 3, 1),
(49, 11, 1, 15);
