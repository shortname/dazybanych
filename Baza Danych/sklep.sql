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
  `idKierownik` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idKierownik_UNIQUE` (`idKierownik` ASC),
  INDEX `index3` (`idAdres` ASC),
  CONSTRAINT `fk_sklepy_1`
    FOREIGN KEY (`idKierownik`)
    REFERENCES `sklepbd`.`personel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
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
