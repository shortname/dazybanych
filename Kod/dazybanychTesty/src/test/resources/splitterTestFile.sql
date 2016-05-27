SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

######WIDOKI
CREATE VIEW `lista_towarow` AS
  SELECT
        pdk.id idProduktu,
        zop.ilosc ilosc,
        pdk.nazwa,
        pdk.opis,
        pdk.cenaBrutto,
        pdc.nazwaProducenta,
        pdk.idProducenta,
        kat.nazwaKategorii,
        pdk.idKategorii
    FROM
        produkty pdk
    JOIN
        producenci pdc
    ON
        pdk.idProducenta = pdc.id
    JOIN
        kategorie kat
    ON
        pdk.idKategorii = kat.id
    LEFT JOIN
        zaopatrzenie zop
    ON
        zop.idProduktu = pdk.id;

#####PROCEDURY

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

CREATE FUNCTION otworzZamowienie(
  id_klienta INT UNSIGNED
)
RETURNS INT UNSIGNED
NOT DETERMINISTIC
BEGIN
  INSERT INTO zamowienia (idKlienta, status) VALUES (id_klienta, 'S');
  RETURN LAST_INSERT_ID();
END //
DELIMITER ;

#####DANE TESTOWE
#konta logowania
INSERT INTO `kontaLogowania` (`id`, `login`, `sha256Haslo`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3'),
(2, 'client', '62608e08adc29a8d6dbc9754e659f125'),
(3, 'personnel', 'f82366a9ddc064585d54e3f78bde3221'),
(4, 'personnel2', 'f82366a9ddc064585d54e3f78bde3221');