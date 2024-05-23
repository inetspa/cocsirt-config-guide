# สำหรับ AlmaLinux 9, Rocky Linux 9, CentOS 9
สามารถใช้ได้กับ AlmaLinux 8, Rocky Linux 8, CentOS 8 <ยังไม่ได้ทำการทดสอบ โปรดตรวจสอบก่อน>
บางส่วนสามารถปรับใช้กับ Debian และ Ubuntu ได้

## เพิ่ม Personal user เข้าไปเป็น group ของ root user
### 1. สร้าง Usesr Personal user และกำหนด password
```
sudo useradd <username>
sudo passwd <username>
```

### 2. เพิ่ม User เข้าไปในกลุ่ม Sudoer
```
sudo visudo
```

เลื่อนไปดู บรรทัดที่เขียนว่า

หากพบว่ามีการ comment อยู่ก็ให้ uncomment และถ้าหากไม่เจอ ก็ให้ทำการเพิ่มเข้าไป
```
%wheel  ALL=(ALL)       ALL
```

หากแก้ไขเสร็จแล้ว ก็ให้ทำการกด `Esc` และใส่ `:wq!` แล้วกด `Enter`

### 3. Check Wheel group
```
sudo cat /etc/group | grep wheel
# จะต้องได้ ผลลัพธ์ดังนี้
wheel:x:10:
```

### 4. หากข้อ 3 ไม่มี ก็ให้ใช้คำสั่งสร้าง Group wheel แต่ถ้าได้ผลลัพธ์ปกติ ก็ข้ามไปทำข้อ 5 ได้เลย
```
sudo groupadd wheel
```

### 5. เพิ่ม User ใน group wheel

เอา Username ที่เราสร้างในข้อ (1) มาเพิ่มในกลุ่ม wheel โดยใช้คำสั่งดังต่อไปนี้
```
sudo usermod -aG wheel <username>
```


### 6. ทดสอบ sudo user
โดยการ SSH เข้าระบบโดยใช้ Username และ Password ในข้อ 1 และใช้คำสั่ง sudo ดังตัวอย่างเช่น
```
sudo ls -al /root
# จะต้องเห็นผลลัพธ์เป็น Dir ของ root นั่นคือ เป็นอันเรียบร้อย
```


## ปิดการ Access ของ user root ไม่ให้สามารถ access เข้ามาในระบบได้ผ่าน SSH
### 1. เข้าระบบโดยใช้ user ทีสร้างใหม่ในขั้นตอนแรก
```
ssh <username>@<host>
```

### 2. แก้ไขไฟล์ `sudo vi /etc/ssh/sshd_config` ดังนี้
```
# แก้ไข root login 
PermitRootLogin yes
# เป็น 
PermitRootLogin no

# แก้ไขให้ใช้ PAM
#UsePAM no
# เป็น
UsePAM yes

# แก้ไขไม่ต้องให้ Reverse lookup dns
#UseDNS no
# เป็น
UseDNS no
```

### 3. Restart sshd
```
sudo systemctl restart sshd
```

### 4. ทดสอบ SSH ด้วย user root
```
ssh root@<host>
```

จะไม่สามารถใช้ user root access ผ่าน ssh เข้าไปได้ จะต้องใช้ผ่าน user personal ที่เราได้สร้างขึ้นในข้อแรกเท่านั้น

## ปิดการเปลี่ยน user จาก personal เป็น user root ผ่าน ssh
ขั้นตอนนี้จะเป็นการปรับเพื่อไม่ให้ user root สามารถ เข้าถึง หรือเปลี่ยน user เป็น root โดยการใช้คำสั่ง `sudo su`, `su - root` เป็นต้น แต่ User ยังสามารถใช้สิทธิ์ root ในการ run ระบบได้โดยกาารใช้คำสั่ง sudo นำหน้าคำสั่งที่ต้องการใช้งาน ดังตัวอย่างเช่น `sudo systemctl restart httpd` 

*การแก้ไขไฟล์ดังต่อไปนี้เป็นการแก้ไขไฟล์ที่สำคัญต่อระบบ ดังนั้น **โปรดใช้ความระมัดระวังในการแก้ไข และตรวจสอบความถูกต้องก่อน** บันทึกทุกครั้ง*

### 1. เข้าไปไปแก้ไขไฟล์ที่ชื่อว่า `/etc/passwd` 
โดยการแก้ไขเราจะใช้คำสั่ง `sudo vi /etc/passwd`
```
# ในบรรทัดแรก เราจะเป็น user root
root:x:0:0:root:/root:/bin/bash

# ใน path ส่วนท้ายจะเป็นว่า /bin/bash ให้เราเปลี่ยนเป็น /sbin/nologin
# หลังจากเปลี่ยนแล้วจะได้ผลดังนี้
root:x:0:0:root:/root:/sbin/nologin
```
เมื่อเสร็จแล้วก็ทำการ save แล้วทดสอบโดยการใช้คำสั่ง
```
su - root
# หรือ
sudo su
```

เมื่อใช้คำสั่งดังกล่าว เราจะต้องไม่สามารถเปลี่ยนไปเป็น user root ได้ จะต้องใช้ Console ในการ access user root ได้เท่านั้น