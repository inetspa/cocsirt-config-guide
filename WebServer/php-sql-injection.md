## การป้องกัน และแก้ไขหากตรวจพบช่องโหว่ SQL Inject ใน PHP

การตรวจพบ SQL Inject สำหรับ PHP จะเกิดกรณีก็ต่อเมื่อ Dev ไม่ได้มีการ Validate ข้อมูลก่อน
และทำการส่ง parameter เข้าไปยัง query โดยตรง ซึ่งทำให้ Hacker สามารถยิง query ผ่าน Input
เข้ามาเพื่อดึงข้อมูล หรือกระทำการบางอย่างในฐานข้อมูลเราได้อย่างง่ายดาย

### ตัวอย่าง #1 - SQL Injection
```php
$offset = $_GET['offset']; // beware, no input validation!
$query  = "SELECT id, name FROM products ORDER BY name LIMIT 20 OFFSET $offset;";
$result = pg_query($conn, $query);
```

คนปกติทั่วไปก็จะใช้งานไม่มีปัญหาอะไร แต่สำหรับ Hacker นั้นก็จะส่งคำสั่งบางอย่างเข้ามาแทนตัวเลข `$offset` ที่ Dev ได้เขียนไว้ ตัวอย่างเช่น
```php
0;
insert into pg_shadow(usename,usesysid,usesuper,usecatupd,passwd)
    select 'crack', usesysid, 't','t','crack'
    from pg_shadow where usename='postgres';
--
```

เมื่อแทนค่าข้อมูล `$offset` เข้าจะกลายเป็น
```php
$query  = "SELECT id, name FROM products ORDER BY name LIMIT 20 OFFSET 0;
insert into pg_shadow(usename,usesysid,usesuper,usecatupd,passwd)
    select 'crack', usesysid, 't','t','crack'
    from pg_shadow where usename='postgres';
--;";
```

โดยที่ Hacker ส่ง query เข้ามาสร้าง หรือทำอะไรกับ database เราได้ง่ายๆ


### ตัวอย่าง #2 - SQL Injection
```php
$query = "UPDATE usertable SET pwd='$pwd' WHERE uid='$uid';";
```

Hacker ก็จะพยายามส่ง parameter เข้ามาแนวๆนี้
```php
// $uid: ' or uid like '%admin%
// จะทำให้ query ออกมาเป็น
$query = "UPDATE usertable SET pwd='...' WHERE uid='' or uid like '%admin%';";

// $pwd: hehehe', trusted=100, admin='yes
$query = "UPDATE usertable SET pwd='hehehe', trusted=100, admin='yes' WHERE
...;";
```


### ตัวอย่าง #3 - SQL Injection
```php
$query  = "SELECT * FROM products WHERE id LIKE '%$prod%'";
$result = mssql_query($query);
```

Hacker ก็อาจจะต้อง prod เข้ามา `a%' exec master..xp_cmdshell 'net user test testpass /ADD' --` และก็จะกลายเป็น
```php
$query  = "SELECT * FROM products
           WHERE id LIKE '%a%'
           exec master..xp_cmdshell 'net user test testpass /ADD' --%'";
$result = mssql_query($query);
```


## การป้องกัน SQL Injection ใน PHP
ทำได้โดยการใช้ Prepare statement หรือใช้ ORM Library อื่นๆ ที่จะมีการเขียนป้องกันไว้อยู่แล้ว
ดีกว่าการที่เราจะเขียน Raw query เอง แต่มีช่องโหว่เกิดขึ้นได้

ตัวอย่างการใช้งาน Prepare statements

```php
# 1
$stmt = $mysqli->prepare("SELECT * FROM REGISTRY where name = ?");
$stmt->execute([$_GET['name']]);


# 2
$stmt = $mysqli->prepare("SELECT * FROM REGISTRY where name LIKE '%?%'");
$stmt->execute([$_GET['name']]);

// placeholder must be used in the place of the whole value
$stmt = $mysqli->prepare("SELECT * FROM REGISTRY where name LIKE ?");
$stmt->execute(["%$_GET[name]%"]);

# 3
// The dynamic SQL part is validated against expected values
$sortingOrder = $_GET['sortingOrder'] === 'DESC' ? 'DESC' : 'ASC';
$productId = $_GET['productId'];
// The SQL is prepared with a placeholder
$stmt = $mysqli->prepare("SELECT * FROM products WHERE id LIKE ? ORDER BY price {$sortingOrder}");
// The value is provided with LIKE wildcards
$stmt->execute(["%{$productId}%"]);
```