คำสั่งสำหรับ Firewalld ของเครื่อง VM


#### เรียกดูสถานะปัจจุบัน
```bash
sudo firewall-cmd --list-all
```

#### การเพิ่ม rule จะใช้ parameter `--add-port`
```bash
# เพิ่ม Firewall rule ตัวอย่างเพิ่ม http, https
sudo filewall-cmd --permanent --add-port 80/tcp
sudo filewall-cmd --permanent --add-port 443/tcp

# เพิ่ม Rule database mysql, mariadb
sudo filewall-cmd --permanent --add-port 3306/tcp

# ทำการ Reload rule แล้ว list-all ดูอีกที ว่าครบถ้วนหรือไม่
sudo firewall-cmd --reload
```

#### การลบ rule จะใช้ parameter `--remove-port`
```bash
# ลบ Port database mysql, mariadb
sudo filewall-cmd --permanent --remove-port 3306/tcp

# ลบ DNS, NTP
sudo filewall-cmd --permanent --remove-port 53/udp
sudo filewall-cmd --permanent --remove-port 123/udp

# ทำการ Reload rule แล้ว list-all ดูอีกที ว่า service ที่ต้องการหายไป หรือไม่
sudo firewall-cmd --reload
```
