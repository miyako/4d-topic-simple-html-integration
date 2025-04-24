# 4d-topic-simple-html-integration
How to integrate 4D data in a web page

This tutorial explains how to

* add a REST API to 4D
* invoke that API from JavaScript
* display result from that API in HTML

## Setup

* create new 4D project
* run > start web server
<img src="https://github.com/user-attachments/assets/fd838b4a-1258-43ed-a416-25c482b7b2d8" width=500 height=auto />

* run > test web server ("WebFolder" is automatically created) 
<img src="https://github.com/user-attachments/assets/d94934a3-afce-4306-96c5-15eb31fabf29" width=500 height=auto />

* download [bootstrap](https://getbootstrap.com/docs/5.3/getting-started/download/)
* copy `js` and `css` to "WebFolder"
* create table "Stuff"
<img src="https://github.com/user-attachments/assets/a1911257-9b77-4294-9186-cf6186e69fec" width=200 height=auto />

* create fake records

```4d
TRUNCATE TABLE([Stuff])
SET DATABASE PARAMETER([Stuff]; Table sequence number; 0)

var $i; $length : Integer
$length:=10000

var $stuff : cs.StuffEntity

For ($i; 1; $length)
	
	$stuff:=ds.Stuff.new()
	$stuff.name:=random_name(32)
	$stuff.save()
	
End for 
```

* random_name

```4d
#DECLARE($length : Integer)->$name : Text

$alphabet:=[]

For ($i; Character code("a"); Character code("z"))
	$alphabet.push(Char($i))
End for 

$random:=Formula($alphabet[Random%$alphabet.length])

For ($i; 1; $length)
	$name:=$name+$random.call()
End for 
```

* create a project method `getstuff`
* goto method properties, enable "4D Tag and URL (4D Action)"
<img src="https://github.com/user-attachments/assets/d135d5a2-92ff-456f-8f47-dc555bdceaea" width=200 height=auto />

* notice the change in icon 
<img src="https://github.com/user-attachments/assets/db01ae55-93f8-4992-9552-16297d822bb5" width=100 height=auto />

* getstuff

```4d
#DECLARE($query : Text)

$query:=Substring($query; 2)  //remove leading /

var $stuff : cs.StuffSelection
$stuff:=ds.Stuff.query("name == :1"; "@"+$query+"@")

var $data : Object
$data:={stuff: $stuff.name}

WEB SEND TEXT(JSON Stringify($data); "application/json")
```
