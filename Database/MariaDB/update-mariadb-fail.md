## วิธีการแก้ปัญหาเมื่อใช้คำสั่ง yum update แล้วติดปัญหา MariaDB ไม่สามารถ Update ได้

เปิดไฟล์ `mariadb.repo` ด้วยคำสั่ง
```
sudo vi /etc/yum.repos.d/mariadb.repo
```

ให้เพิ่ม `#` หน้า baseurl ของเก่า และเพิ่ม baseurl ใหม่
```
baseurl = http://yum.mariadb.org/10.2/rhel7-amd64
baseurl = http://archive.mariadb.org/yum/10.2/rhel7-amd64
```
ผลลัพท์
```
[MariaDB]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/rhel7-amd64
baseurl = http://archive.mariadb.org/yum/10.2/rhel7-amd64
#baseurl = http://yum.mariadb.org/10.10/rhel8-amd64
module_hotfixes=1
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=0
```