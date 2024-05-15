## การจัดการ Password บน Server
มีการควบคุมการเข้าถงระบบโดยใช้งานสิทธระดบ High privileged ดังนี้

- ดําเนินการ Disable Administrator / Root / Admin บนระบบเพื่อป้องกันการโจมตี ในรูปแบบ Brute Force
- มี Policy การเปลี่ยน Password อย่างน้อยทุก 3 เดือน
- มีการกําหนด Role-base access ในการเข้าถึงระบบ
- มีการสร้าง Account ตาม User ที่ใช้งานในระบบ
- มีการตั้ง Password ให้ Complex ตามมาตรฐานอย่างน้อย 10 Digi ตัวอักษรใหญ่, เล็ก, อักขระพิเศษ 

**โดยครอบคลุม Operating System (OS) ของระบบ HIS หรือ Software HIS เป็นอย่างน้อย และต้องมีเอกสารแนบอย่างละเอียดให้ชัดเจน**

### Test password
| ตัวอย่างทดสอบ | เกณฑ์ทดสอบ | ผลลัพธ์ที่คาดหวัง |
|--------------|------|:---:|
| password | เดาง่ายเกินไป | ❌ |
| p@ssw0rd | มีอักขระแต่เดาง่ายเกินไป | ❌ |
| abcdefghij | มีแค่ตัวพิมพ์เล็ก | ❌ |
| AbCdEfGhIjK | มีตัวพิมพ์เล็กผสมตัวพิมพ์ใหญ่ | ❌ |
| A0CdEfGhIj |มีตัวเลขผสมด้วย | ❌ |
| a9Ju*Y5# | มีครบทั้งตัวเล็ก ตัวใหญ่ อักขระพิเศษ แต่ความยาวผ่าน | ❌ |
| 95Q%e91mNV | มีครบเกณฑ์กำหนด และความยาวมากกว่า 10 | ✅ |
| 5w%^g@9UaR | มีครบเกณฑ์กำหนด และความยาวมากกว่า 10 | ✅ |

### การ Setup ระบบเพื่อปิดการเข้าถึงของ User `root` ไม่ให้ remote access เข้ามา
- เปิดไฟล์ `sudo nano /etc/ssh/sshd_config` และแก้ไข Parameter 3 อันนี้ให้เป็น no
```conf
# ไม่อนุญาตให้ Root login เข้ามาได้
PermitRootLogin no

# ปิดการ login เข้าระบบโดยใช้ Password
PasswordAuthentication no
PermitEmptyPasswords no
```

*ระวัง ก่อนการตั้งค่าไม่ให้ `root` เข้าระบบ และเปลี่ยนการ Access แบบไม่ใช้ password จะต้องมีการสร้าง User สำหรับผู้ดูแลระบบ และ เพิ่ม SSH Key ให้เรียบร้อยก่อน ไม่เช่นนั้นจะไม่สามารถ Remote เข้าระบบได้เลย*

- หลังจากแก้ไขไฟล์ `/etc/ssh/sshd_config` แล้วก็ทำการ Restart sshd sersvice
```sh
sudo systemctl restart sshd
```

### การติดตั้ง และตั้งค่า Password ในกลุ่ม Linux Server

#### Linux Red Hat, CentOS, Almalinux, Rocky Linux
โดย Default ตระกูล RHEL จะมีการ Enforce เรื่อง Password Security ไว้เบื้องต้นแล้ว

```
[pam_pwquality] is installed by default on RHEL 8/Rocky Linux 8 even minimum installation, but if it has not been installed

Run [# dnf install libpwquality] to install it.
```

แต่เพื่อให้ผ่านเกณฑ์ประเมิน จะต้องมีการปรับจูนเพิ่มบางอย่าง ดังนี้
- แก้ไขไฟล์ Password Quality `/etc/security/pwquality.conf` และปรับจูนตามรายการด้งนี้
```conf
# Minimum acceptable size for the new password (plus one if
# credits are not disabled which is the default). (See pam_cracklib manual.)
# Cannot be set to lower value than 6.
minlen = 10

# The maximum credit for having digits in the new password. If less than 0
# it is the minimum number of digits in the new password.
dcredit = -1

# The maximum credit for having uppercase characters in the new password.
# If less than 0 it is the minimum number of uppercase characters in the new
# password.
# ucredit = 0
ucredit = -1

# The maximum credit for having lowercase characters in the new password.
# If less than 0 it is the minimum number of lowercase characters in the new
# password.
# lcredit = 0
lcredit = -1

# The maximum credit for having other characters in the new password.
# If less than 0 it is the minimum number of other characters in the new
# password.
ocredit = -1

# Whether the check is enforced by the PAM module and possibly other
# applications.
# The new password is rejected if it fails the check and the value is not 0.
enforcing = 1
```

- หลังจากตั้ง Password policy แล้วลำดับถัดไปก็จะเป็นการตั้ง เวลาหมดอายุสำหรับ Password ใน 90 วัน ซึ่งจะอยู่ในไฟล์ `/etc/login.defs`
```conf
# PASS_MAX_DAYS   Maximum number of days a password may be used.
PASS_MAX_DAYS = 90

# PASS_WARN_AGE   Number of days warning given before a password expires.
PASS_WARN_AGE = 7

# This setting impacts only when creating a user, not impacts to exisiting users.
# If set to exisiting users, run the command [chage -M (days) (user)].
```

- สามารถตรวจสอบ Expires password สำหรับ User ได้โดยใช้คำสั่ง
```bash
$ chage -l admin
Last password change                                    : May 15, 2024
Password expires                                        : Aug 13, 2024
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 7
```

- หาก User ไม่มี Expires password ก็สามารถใช้คำสั่ง เพื่อ Set Policy ให้ User ได้ดังนี้
```bash
$ chage -M 90 admin
```

* Extra สามารถใช้สคริปต์ `days.sh` เพื่อตรวจสอบ Expires password ของ User ในระบบได้
```bash
# Enable execution
$ chmod +x -v days.sh

# Execute script
$ ./days.sh <username>
```


#### Debian, Ubuntu