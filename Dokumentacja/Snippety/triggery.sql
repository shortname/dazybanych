DELIMITER //

CREATE DEFINER = CURRENT_USER TRIGGER `sklepbd`.`klienci_BEFORE_INSERT` BEFORE INSERT ON `klienci` FOR EACH ROW
BEGIN
IF NEW.Imie NOT REGEXP '^[A-Za-z]{3,100}$' THEN
  SIGNAL SQLSTATE '10007'
     SET MESSAGE_TEXT = '[tabla:klienci] - kolumna `Imie` jest niepoprawna!';
END IF;

IF NEW.Nazwisko NOT REGEXP '^[A-Za-z]{3,100}$' THEN
  SIGNAL SQLSTATE '10008'
     SET MESSAGE_TEXT = '[tabla:klienci] - kolumna `Nazwisko` jest niepoprawna!';
END IF;

IF NEW.nip NOT REGEXP '^[0-9]{10}|[0-9]{3}\-[0-9]{3}\-[0-9]{2}\-[0-9]{2}$' THEN
  SIGNAL SQLSTATE '10008'
     SET MESSAGE_TEXT = '[tabla:klienci] - kolumna `nip` jest niepoprawna!';
END IF;

END//
