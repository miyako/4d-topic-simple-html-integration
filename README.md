# 4d-topic-simple-html-integration
How to integrate 4D data in a web page

This tutorial explains how to

* add a REST API to 4D
* invoke that API from JavaScript
* display result from that API in HTML

> [!NOTE]
> The REST API discussed in this article is the classic "web application feature", a.k.a. "[URL form action](https://developer.4d.com/docs/WebServer/httpRequests#4daction)". it is not to be confused with the [REST API](https://developer.4d.com/docs/ja/category/rest-api) activated by exposing ORDA classes.

## Setup

* create new 4D project
* create table "Stuff"
<img src="https://github.com/user-attachments/assets/a1911257-9b77-4294-9186-cf6186e69fec" width=200 height=auto />

* create fake records for "Stuff" 

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

* the project method `random_name` generates a random string of letters

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
* the project method `getstuff` queries the "Stuff" table and returns matching names as a JSON collection

```4d
#DECLARE($query : Text)

$query:=Substring($query; 2)  //remove leading /

var $stuff : cs.StuffSelection
$stuff:=ds.Stuff.query("name == :1"; "@"+$query+"@")

var $data : Object
$data:={stuff: $stuff.name}

WEB SEND TEXT(JSON Stringify($data); "application/json")
```

* goto method properties, enable "4D Tag and URL (4D Action)"
<img src="https://github.com/user-attachments/assets/d135d5a2-92ff-456f-8f47-dc555bdceaea" width=200 height=auto />

* notice the change in icon 
<img src="https://github.com/user-attachments/assets/db01ae55-93f8-4992-9552-16297d822bb5" width=100 height=auto />

* this means the project method `getstuff` can be invoked via the URL `'/4daction/getstuff/{query}`

* run > start web server
<img src="https://github.com/user-attachments/assets/fd838b4a-1258-43ed-a416-25c482b7b2d8" width=500 height=auto />

* run > test web server ("WebFolder" is automatically created) 
<img src="https://github.com/user-attachments/assets/d94934a3-afce-4306-96c5-15eb31fabf29" width=500 height=auto />

* download [bootstrap](https://getbootstrap.com/docs/5.3/getting-started/download/)
* copy `js` and `css` to "WebFolder"
* edit "index.html"

```html
<!doctype html>
<html lang="en" data-bs-theme="dark">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="/css/bootstrap.min.css" rel="stylesheet" />
  </head>
  <body>
    <nav class="navbar navbar-expand-sm bg-body-tertiary">
      <div class="container-fluid">
        <span class="navbar-brand">4D</span>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-sm-0">
            <li class="nav-item">
            </li>
          </ul>
            <input class="form-control me-2 my-query" type="search" placeholder="Search" aria-label="Search">
        </div>
      </div>
    </nav>
    <div id="my-list"><div>
    <script>
        var myList;
        var myQuery;
        function getstuff(query){
            fetch('/4daction/getstuff/' + encodeURIComponent(query))
            .then(response => response.json())
            .then(data => {
                showdata(data.stuff);
            });
            }
        function showdata(data){
            myList.innerHTML = '';
                        
            const table = document.createElement("table");
            table.classList.add("table", "table-striped-columns");
            const thead = document.createElement("thead");
            const tr = document.createElement("tr");
            const th = document.createElement("th");
            const tbody = document.createElement("tbody");
    
            th.textContent = "stuff";
            tr.appendChild(th);
            thead.appendChild(tr);
            table.appendChild(thead);

            data.forEach((item, index) => {
                const tr = document.createElement("tr");
                const td = document.createElement("td");
                td.textContent = item;
                tr.appendChild(td);
                tbody.appendChild(tr);
            });
            
            table.appendChild(tbody);
            myList.appendChild(table);
        }
        document.addEventListener("DOMContentLoaded", function () {
            myList = document.querySelector('#my-list');
            myQuery = document.querySelector('.my-query');
            myQuery.addEventListener('change', function (event) {
                getstuff(event.target.value);
            });
        });
    </script>
    <script src="/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
```

* refresh page in browser

<img src="https://github.com/user-attachments/assets/ca9bc246-7b5a-498a-afbf-7f5b3373d458" width=500 height=auto />

* type random letters; result is displayed in the table below

<img src="https://github.com/user-attachments/assets/fd87b9f7-5c6b-4e27-977d-6140a79fa7c4" width=500 height=auto />
