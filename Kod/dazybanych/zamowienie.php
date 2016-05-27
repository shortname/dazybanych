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
    mysql_query('START TRANSACTION;');
    $id_klienta = $_GET['client'];
    $id_zamowienia = mysql_fetch_row(mysql_query("SELECT otworzZamowienie($id_klienta);"))[0];
    $failure = false;
    foreach ($_GET as $key => $value) {
      if(is_numeric($key) !== false && $value != 0){
        $wynik = mysql_query("SELECT SUM(ilosc) ilosc FROM zaopatrzenie WHERE idProduktu = $key GROUP BY idProduktu;");
        if(mysql_fetch_assoc($wynik)['ilosc'] >= $value){
          mysql_query("CALL dodajProduktDoZamowienia($key, $value, $id_klienta, $id_zamowienia);");
        }else{
          $failure = true;
          break;
        }
      }
    }
    if($failure){
      print("Błąd w zamowieniu!");
      mysql_query('ROLLBACK;');
    }else{
      print("Zamowienie zostało stworzone.");
      mysql_query('COMMIT;');
    }
?>
