DELIMITER //

CREATE FUNCTION otworzZamowienie(
  id_klienta INT UNSIGNED
)
RETURNS INT UNSIGNED
NOT DETERMINISTIC
BEGIN
  INSERT INTO zamowienia (idKlienta, status) VALUES (id_klienta, 'przyjete');
  RETURN LAST_INSERT_ID();
END //
