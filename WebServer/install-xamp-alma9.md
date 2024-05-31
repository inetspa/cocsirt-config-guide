# 1. ติดตั้ง Apache2
```bash
# Install
sudo yum install httpd -y

# Start and enable startup service
sudo systemctl start httpd
sudo systemctl enable httpd

# Install apache mod
sudo yum install mod_ssl mod_php
```

## 1.1 การตั้งค่า ปิด Server token ไม่ให้แสดง Version และ OS ที่ใช้งาน ดังตัวอย่าง
```
# Before
Server: Apache/2.4.57 (AlmaLinux) OpenSSL/3.0.7
```

แก้ไขไฟล์ `/etc/httpd/conf/httpd.conf` โดยการเพิ่มบรรทัดนี้ลงไป
```apache
ServerTokens Prod
ServerSignature Off
```
แล้วก็ทำการ Restart httpd service
```
# After
Server: Apache
```

# 2. ติดตั้ง php
```bash
# Default php8
sudo yum install php -y
```

## 2.1 หากต้องการติดตั้ง version ต่ำกว่า 8 ก็ต้อง Install repository ที่จำเป็นก่อน
```bash
# Specific ver
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm

# Check installable php version
sudo yum module list php

# Example select to install version 7.4
sudo yum module install php:remi-7.4

# Check php version after install
php -v
```

## 2.2 ตั้งค่า Security ปิดการแสดง Version ของ PHP `X-Powered-By: PHP/7.4.33`
แก้ไขไฟล์ `/etc/php.ini` และหาคำว่า
```apache
expose_php = On
```

โดยให้แก้ให้เป็น `Off`
```apache
expose_php = Off
```
หลังจากนั้นก็ Restart php-fpm ด้วย
```bash
sudo systemctl restart php-fpm
```

## 2.3 Setup some important php module
```bash
sudo yum install php-pdo php-mysqli php-mysqlnd 
```

# 3. ติดตั้ง mysql-server
```bash
# Install
sudo yum install mysql-server

# Start and enable startup service
sudo systemctl enable mysqld
sudo systemctl start mysqld
```

## 3.1 หลังจากติดตั้งแล้วให้ Initial config ก่อน โดยใช้คำสั่ง
```bash
$ mysql_secure_installation

# 1. กด Enter ไป และใส่ Password
# 2. Remove anonymous users? yes
# 3. Disallow root login remotely? yes
# 4. Remove test database and access to it? yes
# 5. Reload privilege tables now? yes
```

## 3.2 เข้าไปสร้าง database และ Add user พร้อม grant privilege ให้ user
```bash
# Login to mysql server
mysql -u root -p
```
```sql
# สร้าง Database
> CREATE DATABASE <database_name>;

# สร้าง user
> CREATE USER '<username>'@'%' IDENTIFIED BY '<password>';

# Grant privileges ให้ user 
> GRANT ALL PRIVILEGES ON <database_name>.* TO '<username>'@'%' WITH GRANT OPTION;

# Reload privilegse ที่เพิ่งได้สร้างไป
> FLUSH PRIVILEGES;
```

Cr. https://wiki.crowncloud.net/?How_to_Install_PHP_7_x_in_AlmaLinux_8