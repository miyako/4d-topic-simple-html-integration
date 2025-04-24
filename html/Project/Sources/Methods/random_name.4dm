//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($length : Integer)->$name : Text

$alphabet:=[]

For ($i; Character code:C91("a"); Character code:C91("z"))
	$alphabet.push(Char:C90($i))
End for 

$random:=Formula:C1597($alphabet[Random:C100%$alphabet.length])

For ($i; 1; $length)
	$name:=$name+$random.call()
End for 