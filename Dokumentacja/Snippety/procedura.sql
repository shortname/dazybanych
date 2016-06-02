DELIMITER //
CREATE PROCEDURE dodajProduktDoZamowienia(
  IN id_produktu INT UNSIGNED,
  IN il INT UNSIGNED,
  IN id_klienta INT UNSIGNED,
  IN id_zamowienia INT UNSIGNED
)
BEGIN
  DECLARE zid INT UNSIGNED DEFAULT 0;
  DECLARE zil INT UNSIGNED DEFAULT 0;
  DECLARE zidm INT UNSIGNED DEFAULT 0;
  DECLARE zap CURSOR FOR SELECT id, idMagazynu, ilosc FROM zaopatrzenie WHERE idProduktu = id_produktu AND ilosc > 0 ORDER BY ilosc DESC;
  OPEN zap;
  WHILE il > 0 DO
    FETCH zap INTO zid, zidm, zil;
    IF zil <= il THEN
      DELETE FROM zaopatrzenie WHERE id = zid;
      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (id_zamowienia, zidm, id_produktu, zil);
      SET il = il - zil;
    ELSE
      UPDATE zaopatrzenie SET ilosc = (zil - il) WHERE id = zid;
      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (id_zamowienia, zidm, id_produktu, il);
      SET il = 0;
    END IF;
  END WHILE;
  CLOSE zap;
END //
