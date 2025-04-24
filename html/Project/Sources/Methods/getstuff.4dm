//%attributes = {"invisible":true,"publishedWeb":true,"preemptive":"capable"}
#DECLARE($query : Text)

$query:=Substring:C12($query; 2)  //remove leading /

var $stuff : cs:C1710.StuffSelection
$stuff:=ds:C1482.Stuff.query("name == :1"; "@"+$query+"@")

var $data : Object
$data:={stuff: $stuff.name}

WEB SEND TEXT:C677(JSON Stringify:C1217($data); "application/json")