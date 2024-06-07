## ตัวอย่าง Configuration Guide
เอกสารชุดนี้ทำขึ้นเพื่อใช้เป็นแนวทางในการ Configure ระบบ เพื่อให้ตอบโจทย์ข้อปฏิบัติในเรื่องของ Security ของ Co-CSIRT

### 📖 วิธีการใช้งาน
- เอกสารจะถูกแบ่งออกเป็นแต่ละหัวข้อประเมิน
- กรณีที่เป็น Linux บางคำสั่งจะใช้งานคล้ายกัน แต่ให้ดูว่าเป็น Linux ตระกูลไหน ที่ใช้งานกันเยอะๆ ก็จะพบ 2 ตระกูลคือ
    - Debian จะประกอบไปด้วย Debian, Ubuntu
    - Red Hat จะประกอบไปด้วย Red Hat, CentOS, Almalinux, Rocky Linux

### 📑 สารบัญ
- [Password Management](./PasswordManagement)
- [User Access Management](./UserAccessManagement)
- [Multi-factor authentication](./MultiFactorAuth)
- [Web Server](./WebServer)
- [Container](./Container/installation-guide.md)
- [Troubleshoot](./troubleshoot.md)

### ⬇️ Download Link
- [IBM WinCollect 10.1.8](https://cosirt.sdi.one.th/dl/wincollect-10.1.8-17.x64.msi)

### อัพเดท
- v0.0.0 / 15-May-2024 Initialize project
- v0.0.1 / 23-May-2024 เพิ่ม WebServer configuration และ Troubleshoot
- v0.0.2 / 31-May-2024 เพิ่มการ Hardening ของ Wordpress และ PHP กับ SQL Injection
