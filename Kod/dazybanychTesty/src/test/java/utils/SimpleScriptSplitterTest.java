package utils;

import org.assertj.core.api.Assertions;
import org.junit.Before;
import org.junit.Test;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static org.testng.Assert.*;

public class SimpleScriptSplitterTest {

    Path input = Paths.get("").resolve("src/test/resources/splitterTestFile.sql");

    List<String> expected = new ArrayList<>();

    @Before
    public void init() {
        expected.add("SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS");
        expected.add("CREATE VIEW `lista_towarow` AS\n" +
                "  SELECT\n" +
                "        pdk.id idProduktu,\n" +
                "        zop.ilosc ilosc,\n" +
                "        pdk.nazwa,\n" +
                "        pdk.opis,\n" +
                "        pdk.cenaBrutto,\n" +
                "        pdc.nazwaProducenta,\n" +
                "        pdk.idProducenta,\n" +
                "        kat.nazwaKategorii,\n" +
                "        pdk.idKategorii\n" +
                "    FROM\n" +
                "        produkty pdk\n" +
                "    JOIN\n" +
                "        producenci pdc\n" +
                "    ON\n" +
                "        pdk.idProducenta = pdc.id\n" +
                "    JOIN\n" +
                "        kategorie kat\n" +
                "    ON\n" +
                "        pdk.idKategorii = kat.id\n" +
                "    LEFT JOIN\n" +
                "        zaopatrzenie zop\n" +
                "    ON\n" +
                "        zop.idProduktu = pdk.id");
        expected.add("CREATE PROCEDURE dodajProduktDoZamowienia(\n" +
                "  IN id_produktu INT UNSIGNED,\n" +
                "  IN il INT UNSIGNED,\n" +
                "  IN id_klienta INT UNSIGNED,\n" +
                "  IN id_zamowienia INT UNSIGNED\n" +
                ")\n" +
                "BEGIN\n" +
                "  DECLARE zid INT UNSIGNED DEFAULT 0;\n" +
                "  DECLARE zil INT UNSIGNED DEFAULT 0;\n" +
                "  DECLARE zidm INT UNSIGNED DEFAULT 0;\n" +
                "  DECLARE zap CURSOR FOR SELECT id, idMagazynu, ilosc FROM zaopatrzenie WHERE idProduktu = id_produktu AND ilosc > 0 ORDER BY ilosc DESC;\n" +
                "  OPEN zap;\n" +
                "  WHILE il > 0 DO\n" +
                "    FETCH zap INTO zid, zidm, zil;\n" +
                "    IF zil <= il THEN\n" +
                "      DELETE FROM zaopatrzenie WHERE id = zid;\n" +
                "      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (id_zamowienia, zidm, id_produktu, zil);\n" +
                "      SET il = il - zil;\n" +
                "    ELSE\n" +
                "      UPDATE zaopatrzenie SET ilosc = (zil - il) WHERE id = zid;\n" +
                "      INSERT INTO zamowienia_produkty (idZamowienia, idMagazynu, idProduktu, ilosc) VALUES (id_zamowienia, zidm, id_produktu, il);\n" +
                "      SET il = 0;\n" +
                "    END IF;\n" +
                "  END WHILE;\n" +
                "  CLOSE zap;\n" +
                "END");
        expected.add("CREATE FUNCTION otworzZamowienie(\n" +
                "  id_klienta INT UNSIGNED\n" +
                ")\n" +
                "RETURNS INT UNSIGNED\n" +
                "NOT DETERMINISTIC\n" +
                "BEGIN\n" +
                "  INSERT INTO zamowienia (idKlienta, status) VALUES (id_klienta, 'S');\n" +
                "  RETURN LAST_INSERT_ID();\n" +
                "END");
        expected.add("INSERT INTO `kontaLogowania` (`id`, `login`, `sha256Haslo`) VALUES\n" +
                "(1, 'admin', '21232f297a57a5a743894a0e4a801fc3'),\n" +
                "(2, 'client', '62608e08adc29a8d6dbc9754e659f125'),\n" +
                "(3, 'personnel', 'f82366a9ddc064585d54e3f78bde3221'),\n" +
                "(4, 'personnel2', 'f82366a9ddc064585d54e3f78bde3221')");
    }

    @Test
    public void shouldSplit() {
        List<String> actual = SimpleScriptSplitter.splitQueriesFromFile(input);

        Assertions.assertThat(actual).isEqualTo(expected);
    }

}