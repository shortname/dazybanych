<?php
if(isset($_POST['salesman']) && isset($_POST['client'])){
    
}else{
    print "Niepoprawne zamówienie!<br />"
    . "<a href='index.php'>Powrót</a>";
}
?>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <?php
            if(isset($_POST['salesman']) && isset($_POST['client'])){
                $client = $_POST['client'];
                $salesman = $_POST['salesman'];
                print "<b>Zamawiający: $client</b><br />"
                        . "<b>Sprzedawca: $salesman</b></b>";
            }else{
                print "Niepoprawne zamówienie!<br />"
                . "<a href='index.php'>Powrót</a>";
            }
        ?>
    </body>
</html>
