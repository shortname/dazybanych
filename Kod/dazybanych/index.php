<?php
$link = mysql_connect('localhost', 'root', 'admin');
if(!$link){
    die("<h1>Connection error</h1>");
}
$db = mysql_select_db('sklepbd');
if(!$db){
    die("<h1>Database error</h1>");
}
mysql_set_charset("utf8");
$wareList = "SELECT "
            . "SUM(zop.ilosc) ilosc, "
            . "pdk.*, "
            . "pdc.nazwaProducenta "
        . "FROM "
            . "produkty pdk "
        . "JOIN "
            . "producenci pdc "
        . "ON "
            . "pdk.idProducenta = pdc.id "
        . "LEFT JOIN "
            . "zaopatrzenie zop "
        . "ON "
            . "zop.idProduktu = pdk.id "
        . "GROUP BY "
            . "pdk.id;";
$producers = "SELECT
    t.*
FROM
    (SELECT
        pdc.nazwaProducenta,
        SUM(`ilosc`) ilosc
    FROM
        `producenci` pdc
    JOIN
        `produkty` pdk
    ON
        pdc.id = pdk.idProducenta
    JOIN
        `zaopatrzenie` zap
    ON  
        pdk.id = zap.idProduktu
    GROUP BY
        pdc.id) t
WHERE
    t.ilosc != 0;";
$categories = "SELECT
    t.*
FROM
    (SELECT
        kat.nazwaKategorii,
        SUM(`ilosc`) ilosc
    FROM
        `kategorie` kat
    JOIN
        `produkty` pdk
    ON
        kat.id = pdk.idKategorii
    JOIN
        `zaopatrzenie` zap
    ON  
        pdk.id = zap.idProduktu
    GROUP BY
        kat.id) t
WHERE
    t.ilosc != 0;";
?>
<html>
        <head>
            <title>Sklep</title>
            <meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
        </head>
    <body>
        <div id="list" style="width:75%;">
        <?php
        $wynik = mysql_query($wareList);
        print "<table>"
            . "<thead>"
                    . "<tr><th>Nazwa</th><th>Producent</th><th>Opis</th><th>Cena brutto</th><th>Dostępne</th></tr>"
                    . "</thead"
                    . "<tbody>";
            while($rekord = mysql_fetch_assoc($wynik)){
                $nazwa = $rekord['nazwa'];
                $producent = $rekord['nazwaProducenta'];
                $opis = $rekord['opis'];
                $cenaBrutto = $rekord['cenaBrutto'];
                $ilosc = $rekord['ilosc'];
                print "<tr><td>$nazwa</td><td>$producent</td><td>$opis</td><td>$cenaBrutto</td><td>".($ilosc==null ? "Brak towaru!" : $ilosc)."</td></tr>";
            }
            print "</tbody></table></body></html>";
        ?>
        </div>
        <div id='filter' style='width:20%; position: fixed; top:0px; right:0px;'>
            <form method='GET' action='index.php'>
                <h2>Producent</h2>
                <?php
                    $wynik = mysql_query($producers);
                    while($rekord = mysql_fetch_assoc($wynik)){
                        $name = $rekord['nazwaProducenta'];
                        $index = "producer_" . $rekord['nazwaProducenta'];
                        $value = false;
                        if(isset($_GET[$index]) && $_GET[$index] == true)
                            $value = true;
                        print "<input type='checkbox' name='producer_". $name ."' value='false' checked='".$value."' />" . $name . "<br />";
                    }
                ?>
                <h2>Kategoria</h2>
                <?php
                    $wynik = mysql_query($categories);
                    while($rekord = mysql_fetch_assoc($wynik)){
                        $name = $rekord['nazwaKategorii'];
                        $index = "category_" . $rekord['nazwaKategorii'];
                        $value = false;
                        if(isset($_GET[$index]))
                            $value = $_GET[$index];
                        print "<input type='checkbox' name='category_". $name ."' value='".$value."' />" . $name . "<br />";
                    }
                ?>
                <input type='submit' value="Filtruj" />
            </form>
        </div>
    </body>
</html>
