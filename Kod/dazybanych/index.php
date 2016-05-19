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
function wareList(){
    $filter = '';
    if(isset($_GET['producer'])){
        $producers = $_GET['producer'];
        $filter .= "WHERE (";
        foreach($producers as $key => $value){
            if($key != 0)
                $filter.="OR ";
            $filter .= "idProducenta = $value ";
        }
        $filter .= ")";
    }
    if(isset($_GET['category'])){
        $producers = $_GET['category'];
        if(strlen($filter) == 0)
            $filter .= 'WHERE (';
        else
            $filter .= "AND (";
        foreach($producers as $key => $value){
            if($key != 0)
                $filter.="OR ";
            $filter .= "idKategorii = $value ";
        }
        $filter .= ")";
    }
    return "SELECT
      *,
      SUM(ilosc) ilosc
    FROM
        `lista_towarow`
    ".$filter."
    GROUP BY
      idProduktu;";
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
$salesmen = "SELECT id, imie, nazwisko FROM personel ORDER BY nazwisko;";
?>
<html>
        <head>
            <title>Sklep</title>
            <meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
            <link rel="stylesheet" type="text/css" href="style/lista_towarow.css"/>
        </head>
    <body>
        <div id="list" style="width:75%;">
            <form method="POST" action="zamowienie.php">
                <div  style="width:49%; display: inline-block;">
                    Klient:
                    <select name="client" style="width:100%;">
                        <?php
                            $wynik = mysql_query($clients);
                            while($rekord = mysql_fetch_assoc($wynik)){
                                $imie = $rekord['imie'];
                                $nazwisko = $rekord['nazwisko'];
                                $id = $rekord['id'];
                                print "<option value='$id'>$imie $nazwisko</option>";
                            }
                        ?>
                    </select>
                </div>
                <div style="width:49%; display: inline-block;">
                    Sprzedawca:
                    <select name="salesman" style="width:100%">
                        <?php
                            $wynik = mysql_query($salesmen);
                            while($rekord = mysql_fetch_assoc($wynik)){
                                $imie = $rekord['imie'];
                                $nazwisko = $rekord['nazwisko'];
                                $id = $rekord['id'];
                                print "<option value='$id'>$imie $nazwisko</option>";
                            }
                        ?>
                    </select>
                </div>
                <?php
                $wynik = mysql_query(wareList());
                print "<table class='border' style='width:100%;'>"
                    . "<thead>"
                            . "<tr><th>Kategoria</th><th>Nazwa</th><th>Producent</th><th>Cena brutto</th><th>Dostępne</th><th>Zamówienie</th></tr>"
                            . "</thead"
                            . "<tbody>";
                    while($rekord = mysql_fetch_assoc($wynik)){
                        $id = $rekord['idProduktu'];
                        $nazwa = $rekord['nazwa'];
                        $producent = $rekord['nazwaProducenta'];
                        $kategoria = $rekord['nazwaKategorii'];
                        $opis = $rekord['opis'];
                        $cenaBrutto = $rekord['cenaBrutto'];
                        $ilosc = $rekord['ilosc'];
                        $zamowienie = "";
                        if($ilosc != NULL)
                            $zamowienie = "<input type='number' name='order_$id' min='0' max='".($ilosc==null ? 0 : $ilosc)."' value='0'>";
                        print "<tr><td>$kategoria</td><td><span id='nazwa'>$nazwa</span><br /><span style='font-size:10pt;'>$opis</span></td><td id='producent'>$producent</td><td>$cenaBrutto</td><td>".($ilosc==null ? "Brak towaru!" : $ilosc)."</td><td>$zamowienie</td></tr>";
                    }
                    print "</tbody></table></body></html>";
                ?>
                <div style="display: inline-block;">
                    <input type="radio" name="payment" value="card"/> Karta<br />
                </div>
                <div style="display: inline-block;">
                    <input type="radio" name="payment" value="cash"/> Gotówka<br />
                </div>
                <div style="display: inline-block;">
                    <input type="radio" name="payment" value="transfer"/> Przelew<br />
                </div><br />
                <div style="display: inline-block;">
                    <input type="submit" value="Zamów" />
                </div>
            </form>
        </div>
        <div id='filter' style='width:20%; position: fixed; top:0px; right:0px;'>
            <form method='GET' action='index.php'>
                <h2>Producent</h2>
                <?php
                    $wynik = mysql_query($producers);
                    while($rekord = mysql_fetch_assoc($wynik)){
                        $id = $rekord['id'];
                        $name = $rekord['nazwaProducenta'];
                        $index = "producer";
                        $value = '';
                        if(isset($_GET[$index]) && in_array($id, $_GET[$index]))
                            $value = 'checked=\'true\'';
                        print "<input type='checkbox' name='". $index ."[]' value='".$id."' ".$value."' />" . $name . "<br />";
                    }
                ?>
                <h2>Kategoria</h2>
                <?php
                    $wynik = mysql_query($categories);
                    while($rekord = mysql_fetch_assoc($wynik)){
                        $id = $rekord['id'];
                        $name = $rekord['nazwaKategorii'];
                        $index = "category";
                        $value = '';
                        if(isset($_GET[$index]) && in_array($id, $_GET[$index]))
                            $value = 'checked=\'true\'';
                        print "<input type='checkbox' name='". $index ."[]' value='".$id."' ".$value."' />" . $name . "<br />";
                    }
                ?>
                <input type='submit' value="Filtruj" />
            </form>
        </div>
    </body>
</html>
