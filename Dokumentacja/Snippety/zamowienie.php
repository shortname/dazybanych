<?php
mysql_query('START TRANSACTION;');
$id_klienta = $_GET['client'];
$id_zamowienia = mysql_fetch_row(mysql_query("SELECT otworzZamowienie($id_klienta);"))[0];
$failure = false;
$empty = true;
foreach ($_GET as $key => $value) {
  if(is_numeric($key) !== false && $value != 0){
    $empty = false;
    $wynik = mysql_query("SELECT SUM(ilosc) ilosc FROM zaopatrzenie WHERE idProduktu = $key GROUP BY idProduktu;");
    if(mysql_fetch_assoc($wynik)['ilosc'] >= $value){
      mysql_query("CALL dodajProduktDoZamowienia($key, $value, $id_klienta, $id_zamowienia);");
    }else{
      $failure = true;
      break;
    }
  }
}
if($failure || $empty){
  print("Błąd w zamówieniu!");
  mysql_query('ROLLBACK;');
}else{
  print("Zamowienie zostało stworzone.");
  mysql_query('COMMIT;');
}
?>
