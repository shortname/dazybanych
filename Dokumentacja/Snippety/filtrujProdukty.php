<?php
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
$wynik = mysqli_query($link, wareList());
print "<table class='border' style='width:100%;'>"
    . "<thead>"
            . "<tr>
            <th>Kategoria</th>
            <th>Nazwa</th>
            <th>Producent</th>
            <th>Cena brutto</th>
            <th>Dostępne</th>
            <th>Zamówienie</th></tr>"
            . "</thead>"
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
      print "<tr class='product' id='$id'>
      <td id='kategoria'>$kategoria</td>
      <td><span id='nazwa'>$nazwa</span><br /><span style='font-size:10pt;'>$opis</span></td>
      <td id='producent'>$producent</td>
      <td>$cenaBrutto</td>
      <td id='ilosc'>".($ilosc==null ? "Brak towaru!" : $ilosc)."</td>
      <td>$zamowienie</td></tr>";
  }
}
print "</tbody></table></body></html>";
?>
