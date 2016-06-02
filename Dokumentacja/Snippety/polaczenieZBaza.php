<?php
$link = mysqli_connect('localhost', 'root', 'admin', 'sklepbd');
if(!$link){
    die("<h1>Connection error</h1>");
}
mysqli_set_charset($link, "utf8");
?>
