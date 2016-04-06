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
  `idKontaLogowania` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `sha256Haslo` VARCHAR(45) NOT NULL,
  `ostatnieLogowanie` DATETIME NULL,
  PRIMARY KEY (`idKontaLogowania`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`adresy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`adresy` (
  `idAdres` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `miasto` VARCHAR(45) NOT NULL,
  `wojewodztwo` VARCHAR(45) NULL,
  `kodPocztowy` VARCHAR(45) NOT NULL,
  `ulica` VARCHAR(45) NOT NULL,
  `nrDomu` VARCHAR(45) NOT NULL,
  `nrLokalu` VARCHAR(45) NULL,
  PRIMARY KEY (`idAdres`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`kontakty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`kontakty` (
  `idKontakt` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `telefon1` VARCHAR(45) NOT NULL,
  `telefon2` VARCHAR(45) NULL,
  `fax` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idKontakt`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`klienci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`klienci` (
  `idKlienta` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `idKontoLogowania` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  `idKontakt` INT UNSIGNED NOT NULL,
  `nip` VARCHAR(45) NULL,
  `dataDodania` DATETIME NOT NULL,
  PRIMARY KEY (`idKlienta`),
  INDEX `index1` (`idKontoLogowania` ASC),
  INDEX `index2` (`idAdres` ASC),
  INDEX `index3` (`idKontakt` ASC),
  CONSTRAINT `fk_klienci_1`
    FOREIGN KEY (`idKontoLogowania`)
    REFERENCES `sklepbd`.`kontaLogowania` (`idKontaLogowania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_klienci_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`idAdres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_klienci_3`
    FOREIGN KEY (`idKontakt`)
    REFERENCES `sklepbd`.`kontakty` (`idKontakt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`magazyny`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`magazyny` (
  `idMagazyn` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idKierownik` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idMagazyn`),
  UNIQUE INDEX `idKierownik_UNIQUE` (`idKierownik` ASC),
  INDEX `index3` (`idAdres` ASC),
  CONSTRAINT `fk_sklepy_1`
    FOREIGN KEY (`idKierownik`)
    REFERENCES `sklepbd`.`personel` (`idPracownika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sklepy_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`idAdres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`personel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`personel` (
  `idPracownika` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `idKontoLogowania` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  `idKontakt` INT UNSIGNED NOT NULL,
  `idMagazyn` INT UNSIGNED NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPracownika`),
  INDEX `index2` (`idKontoLogowania` ASC),
  INDEX `index3` (`idAdres` ASC),
  INDEX `index4` (`idKontakt` ASC),
  INDEX `index5` (`idMagazyn` ASC),
  CONSTRAINT `fk_personel_1`
    FOREIGN KEY (`idKontoLogowania`)
    REFERENCES `sklepbd`.`kontaLogowania` (`idKontaLogowania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_2`
    FOREIGN KEY (`idAdres`)
    REFERENCES `sklepbd`.`adresy` (`idAdres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_3`
    FOREIGN KEY (`idKontakt`)
    REFERENCES `sklepbd`.`kontakty` (`idKontakt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_personel_4`
    FOREIGN KEY (`idMagazyn`)
    REFERENCES `sklepbd`.`magazyny` (`idMagazyn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`producenci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`producenci` (
  `idProducenta` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwaProducenta` VARCHAR(45) NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idProducenta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`kategorie` (
  `idKategorii` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwaKategorii` VARCHAR(45) NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idKategorii`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`produkty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`produkty` (
  `idProduktu` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazwa` VARCHAR(45) NOT NULL,
  `idProducenta` INT UNSIGNED NOT NULL,
  `idKategorii` INT UNSIGNED NOT NULL,
  `opis` TEXT NULL,
  `cenaNetto` DECIMAL(10,2) NOT NULL,
  `cenaBrutto` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idProduktu`),
  INDEX `index2` (`idProducenta` ASC),
  INDEX `index3` (`idKategorii` ASC),
  CONSTRAINT `fk_produkty_1`
    FOREIGN KEY (`idProducenta`)
    REFERENCES `sklepbd`.`producenci` (`idProducenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produkty_2`
    FOREIGN KEY (`idKategorii`)
    REFERENCES `sklepbd`.`kategorie` (`idKategorii`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`zaopatrzenie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`zaopatrzenie` (
  `idZaopatrzenia` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idProduktu` INT UNSIGNED NOT NULL,
  `idMagazynu` INT UNSIGNED NOT NULL,
  `ilosc` DECIMAL UNSIGNED NOT NULL,
  `dataZmiany` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idZaopatrzenia`),
  INDEX `index2` (`idProduktu` ASC),
  INDEX `index3` (`idMagazynu` ASC),
  CONSTRAINT `fk_zaopatrzenie_1`
    FOREIGN KEY (`idProduktu`)
    REFERENCES `sklepbd`.`produkty` (`idProduktu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_zaopatrzenie_2`
    FOREIGN KEY (`idMagazynu`)
    REFERENCES `sklepbd`.`magazyny` (`idMagazyn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`sprzedaz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`sprzedaz` (
  `idSprzedazy` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idZaopatrzenia` INT UNSIGNED NOT NULL,
  `idKlienta` INT UNSIGNED NOT NULL,
  `idPracownika` INT UNSIGNED NOT NULL,
  `dataSprzeazy` DATETIME NOT NULL,
  PRIMARY KEY (`idSprzedazy`),
  INDEX `index2` (`idZaopatrzenia` ASC),
  INDEX `index3` (`idKlienta` ASC),
  INDEX `index4` (`idPracownika` ASC),
  CONSTRAINT `fk_sprzedaz_1`
    FOREIGN KEY (`idZaopatrzenia`)
    REFERENCES `sklepbd`.`zaopatrzenie` (`idZaopatrzenia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sprzedaz_2`
    FOREIGN KEY (`idKlienta`)
    REFERENCES `sklepbd`.`klienci` (`idKlienta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sprzedaz_3`
    FOREIGN KEY (`idPracownika`)
    REFERENCES `sklepbd`.`personel` (`idPracownika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`platnosci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`platnosci` (
  `idPlatnosci` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idKlienta` INT UNSIGNED NOT NULL,
  `idPracownika` INT UNSIGNED NOT NULL,
  `idSprzedazy` INT UNSIGNED NULL,
  `rodzaj` ENUM('karta','gotowka','przelew') NULL,
  `ilosc` DECIMAL NOT NULL,
  `dataPlatnosci` DATETIME NOT NULL,
  PRIMARY KEY (`idPlatnosci`),
  INDEX `index2` (`idKlienta` ASC),
  INDEX `index3` (`idPracownika` ASC),
  INDEX `index4` (`idSprzedazy` ASC),
  CONSTRAINT `fk_platnosci_1`
    FOREIGN KEY (`idKlienta`)
    REFERENCES `sklepbd`.`klienci` (`idKlienta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_platnosci_2`
    FOREIGN KEY (`idPracownika`)
    REFERENCES `sklepbd`.`personel` (`idPracownika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_platnosci_3`
    FOREIGN KEY (`idSprzedazy`)
    REFERENCES `sklepbd`.`sprzedaz` (`idSprzedazy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sklepbd`.`table1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`table1` (
)
ENGINE = InnoDB;

USE `sklepbd` ;

-- -----------------------------------------------------
-- Placeholder table for view `sklepbd`.`sprzedazWSklepach`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`sprzedazWSklepach` (`store` INT, `manager` INT, `total_sales` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sklepbd`.`listaProduktow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`listaProduktow` (`FID` INT, `title` INT, `description` INT, `category` INT, `price` INT, `length` INT, `rating` INT, `actors` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sklepbd`.`listaKlientow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`listaKlientow` (`ID` INT, `name` INT, `address` INT, `zip code` INT, `phone` INT, `city` INT, `country` INT, `notes` INT, `SID` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sklepbd`.`listaPersonelu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sklepbd`.`listaPersonelu` (`ID` INT, `name` INT, `address` INT, `zip code` INT, `phone` INT, `city` INT, `country` INT, `SID` INT);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
