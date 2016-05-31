<?php
$link = mysqli_connect('localhost', 'root', 'admin', 'sklepbd');
if(!$link){
    die("<h1>Connection error</h1>");
}
mysqli_set_charset($link, "utf8");
function wareList(){
    $pros = "";
    if(isset($_GET['producer'])){
        $pros = implode(",", $_GET['producer']);
    }
    $cats = "";
    if(isset($_GET['category'])){
        $cats = implode(",", $_GET['category']);
    }
    return "CALL filtrujProdukty('$pros', '$cats');";
}
$producers = "SELECT
    t.*
FROM
    (SELECT
        pdc.id id,
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
        kat.id id,
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
$clients = "SELECT id, imie, nazwisko FROM klienci ORDER BY nazwisko;";
?>
<html>
        <head>
            <title>Sklep</title>
            <meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
            <link rel="stylesheet" type="text/css" href="style/lista_towarow.css"/>
        </head>
    <body>
        <div id='filter' style='width:20%; position: fixed; top:0px; right:0px;'>
            <form method='GET' action='index.php'>
                <h2>Producent</h2>
                <?php
                    $wynik = mysqli_query($link, $producers);
                    while($rekord = mysqli_fetch_assoc($wynik)){
                        $id = $rekord['id'];
                        $name = $rekord['nazwaProducenta'];
                        $index = "producer";
                        $value = '';
                        if(isset($_GET[$index]) && in_array($id, $_GET[$index]))
                            $value = 'checked=\'true\'';
                        print "<input type='checkbox' id='pro$id' name='". $index ."[]' value='".$id."' ".$value."' />" . $name . "<br />";
                    }
                ?>
                <h2>Kategoria</h2>
                <?php
                    $wynik = mysqli_query($link, $categories);
                    while($rekord = mysqli_fetch_assoc($wynik)){
                        $id = $rekord['id'];
                        $name = $rekord['nazwaKategorii'];
                        $index = "category";
                        $value = '';
                        if(isset($_GET[$index]) && in_array($id, $_GET[$index]))
                            $value = 'checked=\'true\'';
                        print "<input type='checkbox' id='cat$id' name='". $index ."[]' value='".$id."' ".$value."' />" . $name . "<br />";
                    }
                    if(isset($_GET['filtered']))
                      print("<input type='hidden' id='reallyFiltered' value='true' />");
                ?>
                <input type='hidden' name='filtered' value='true' />
                <input type='submit' id='filterButton' value="Filtruj" />
            </form>
        </div>
        <div id="list" style="width:75%;">
            <form method="GET" action="zamowienie.php">
                <div  style="width:49%; display: inline-block;">
                    Klient:
                    <select name="client" id="client" style="width:100%;">
                        <?php
                            $wynik = mysqli_query($link, $clients);
                            while($rekord = mysqli_fetch_assoc($wynik)){
                                $imie = $rekord['imie'];
                                $nazwisko = $rekord['nazwisko'];
                                $id = $rekord['id'];
                                print "<option value='$id'>$imie $nazwisko</option>";
                            }
                        ?>
                    </select>
                </div>
                <?php
                $wynik = mysqli_query($link, wareList());
                print "<table class='border' style='width:100%;'>"
                    . "<thead>"
                            . "<tr><th>Kategoria</th><th>Nazwa</th><th>Producent</th><th>Cena brutto</th><th>Dostępne</th><th>Zamówienie</th></tr>"
                            . "</thead"
                            . "<tbody>";
                    if($wynik){
                      while($rekord = mysqli_fetch_assoc($wynik)){
                          $id = $rekord['idProduktu'];
                          $nazwa = $rekord['nazwa'];
                          $producent = $rekord['nazwaProducenta'];
                          $kategoria = $rekord['nazwaKategorii'];
                          $opis = $rekord['opis'];
                          $cenaBrutto = $rekord['cenaBrutto'];
                          $ilosc = $rekord['ilosc'];
                          $zamowienie = "";
                          if($ilosc != NULL)
                              $zamowienie = "<input type='number' id='order' name='$id' min='0' max='".($ilosc==null ? 0 : $ilosc)."' value='0'>";
                          print "<tr class='product' id='$id'><td id='kategoria'>$kategoria</td><td><span id='nazwa'>$nazwa</span><br /><span style='font-size:10pt;'>$opis</span></td><td id='producent'>$producent</td><td>$cenaBrutto</td><td id='ilosc'>".($ilosc==null ? "Brak towaru!" : $ilosc)."</td><td>$zamowienie</td></tr>";
                      }
                    }
                    print "</tbody></table></body></html>";
                ?>
                <div style="display: inline-block;">
                    <input type="submit" id="orderButton" value="Zamów" />
                </div>
            </form>
        </div>
    </body>
</html>
