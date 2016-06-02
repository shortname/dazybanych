CREATE TABLE IF NOT EXISTS `sklepbd`.`klienci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `idKontoLogowania` INT UNSIGNED NOT NULL,
  `idAdres` INT UNSIGNED NOT NULL,
  `idKontakt` INT UNSIGNED NOT NULL,
  `nip` VARCHAR(45) NULL,
  `dataDodania` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
