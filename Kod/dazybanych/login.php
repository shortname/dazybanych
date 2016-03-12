<?php
    $login_page = "<html>"
        . "<head><title>Sklep</title>"
            . "<meta charset='UTF-8'/></head>"
        . "<body>"
                . "<form action='login.php' method='POST'>"
                . "Login: <input type='text' name='login' /><br />"
                . "Password: <input type='password' name='password' /><br />"
                . "<input type='submit' text='Login'/>"
                . "</form>"
                . "</body>"
                . "</html>";
    if(!isset($_POST['login']) || !isset($_POST['password'])){
        echo $login_page;
    }else{
        $login = $_POST['login'];
        $password = $_POST['password'];
        $link = mysql_connect('localhost', 'root', 'admin');
        if(!$link){
            die("<h1>Connection error</h1>");
        }
        $db = mysql_select_db('sklep_sportowy');
        if(!$db){
            die("<h1>Database error</h1>");
        }
        $wynik = mysql_query("SELECT * FROM users WHERE login = '$login' AND password = '$password'");
        $found = false;
        while($rekord = mysql_fetch_assoc($wynik)){
            $found = true;
        }
        if(!$found){
            echo $login_page;
        }else{
            $wynik = mysql_query("SELECT * FROM promocje");
            print "<table>"
            . "<thead>"
                    . "<tr><th>Id</th><th>Nazwa</th><th>Cena (PLN)</th><th>Jednostka</th></tr>"
                    . "</thead"
                    . "<tbody>";
            while($rekord = mysql_fetch_assoc($wynik)){
                $id = $rekord['id'];
                $nazwa = $rekord['nazwa'];
                $cena = $rekord['cena'];
                $jednostka = $rekord['jednostka'];
                print "<tr><td>$id</td><td>$nazwa</td><td>$cena</td><td>$jednostka</td></tr>";
            }
            print "</tbody></table>";
        }
        mysql_close();
    }
?>
</html>

