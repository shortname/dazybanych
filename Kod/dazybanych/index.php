<?php
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
        . "JOIN "
            . "zaopatrzenie zop "
        . "ON "
            . "zop.idProduktu = pdk.id "
        . "GROUP BY "
            . "pdk.id;"
?>
<html>
        <head>
            <title>Sklep</title>
            <meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
        </head>
    <body>
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
                print "<tr><td>$nazwa</td><td>$producent</td><td>$opis</td><td>$cenaBrutto</td><td>$ilosc</td></tr>";
            }
            print "</tbody></table></body></html>";
        ?>
    </body>
</html>
