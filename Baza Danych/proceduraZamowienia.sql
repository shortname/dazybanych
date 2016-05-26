DELIMITER //
CREATE PROCEDURE dodajProduktDoZamowienia(
  IN id_produktu INT UNSIGNED,
  IN il INT UNSIGNED,
  OUT wynik INT UNSIGNED
)
BEGIN
  DECLARE zid INT UNSIGNED DEFAULT 0;
  DECLARE zil INT UNSIGNED DEFAULT 0;
  DECLARE zidm INT UNSIGNED DEFAULT 0;
  DECLARE zap CURSOR FOR SELECT id, idMagazynu, ilosc FROM zaopatrzenie WHERE idProduktu = id_produktu AND ilosc > 0;
  OPEN zap;
  FETCH zap INTO zid, zidm, zil;
  IF zil <= il THEN
    DELETE FROM zaopatrzenie WHERE id = zid;
    SET il = il - zil;
  ELSE
    UPDATE zaopatrzenie SET ilosc = (zil - il) WHERE id = zid;
    SET il = 0;
  CLOSE zap;
END //
DELIMITER ;
