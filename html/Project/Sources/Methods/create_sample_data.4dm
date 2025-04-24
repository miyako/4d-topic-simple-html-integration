//%attributes = {"invisible":true,"preemptive":"capable"}
TRUNCATE TABLE:C1051([Stuff:1])
SET DATABASE PARAMETER:C642([Stuff:1]; Table sequence number:K37:31; 0)

var $i; $length : Integer
$length:=10000

var $stuff : cs:C1710.StuffEntity

For ($i; 1; $length)
	
	$stuff:=ds:C1482.Stuff.new()
	$stuff.name:=random_name(32)
	$stuff.save()
	
End for 