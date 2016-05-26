CREATE PROCEDURE dodajProduktDoZamowienia(
  IN id_produktu INT UNSIGNED,
  IN il INT UNSIGNED,
  IN id_klienta INT UNSIGNED,
  IN idZamowienia INT UNSIGNED
)
BEGIN
  DECLARE zid INT UNSIGNED DEFAULT 0;
  DECLARE zil INT UNSIGNED DEFAULT 0;
  DECLARE zap CURSOR FOR SELECT id, idMagazynu, ilosc FROM zaopatrzenie WHERE idProduktu = id_produktu AND ilosc > 0;
  OPEN zap;
  WHILE il > 0 DO
    FETCH zap INTO zid, zidm, zil;
    IF zil <= il THEN
      DELETE FROM zaopatrzenie WHERE id = zid;
      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (zidz, zidm, id_produktu, zil);
      SET il = il - zil;
    ELSE
      UPDATE zaopatrzenie SET ilosc = (zil - il) WHERE id = zid;
      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (zidz, zidm, id_produktu, il);
      SET il = 0;
    END IF;
  END WHILE;
  CLOSE zap;
END //

CREATE PROCEDURE tworzZamowienie(
  IN id_produktow VARCHAR(255),
  IN ilosci VARCHAR(255),
  IN id_klienta INT UNSIGNED
)
BEGIN
  DECLARE zidz INT UNSIGNED DEFAULT 0;
  DECLARE il INT UNSIGNED DEFAULT 0;
  DECLARE id_produktu INT UNSIGNED DEFAULT 0;
  DECLARE zidm INT UNSIGNED DEFAULT 0;
  INSERT INTO zamowienia (idKlienta, status) VALUES (id_klienta, 'S');
  SET zidz = LAST_INSERT_ID();
  SET id_produktow = CONCAT(id_produktu, ',');
  SET ilosci = CONCAT(ilosc, ',');
  WHILE LENGTH(id_produktow) > 0 DO
    SET id_produktu = SUBSTRING_INDEX(id_produktow, ',', 1);
    SET il = SUBSTRING_INDEX(id_produktow, ',', 1);
    SET id_produktow = SUBSTRING(id_produktow, (LOCATE(',', id_produktow) + 1));
    SET ilosci = SUBSTRING(id_produktow, (LOCATE(',', id_produktow) + 1));
    CALL dodajProduktDoZamowienia(id_produktu, il, id_klienta, zidz);
  END WHILE;
END //
