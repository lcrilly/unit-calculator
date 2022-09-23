<?php

$body = file_get_contents('php://input');
$json = json_decode($body);

$r["result"] = $json->operand**2;

header("Content-Type: application/json; charset=utf-8");
echo json_encode($r, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

?>
