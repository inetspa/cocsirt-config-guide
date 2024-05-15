## มาตรการการรักษาความปลอดภัยการเข้าถึงระบบโดยใช้ 2Factor
ต้องมีการยืนยันตัวตนอย่างใดอย่างหนึ่ง 
- Multi-Factor Authentication (2FA)
- SSH Login private key


*คำแนะนำ*
หากใช้งาน RSA Key ควรจะต้องมีความยาวอย่างน้อย 2048 แต่แนะนำให้ใช้ **RSA ความยาว 4096**
แต่ในปัจจุบันมีอัลกอลิทึมที่ปลอดภัยมากกว่า RSA แต่ใช้ความยาว Key สั้นกว่า คือ ED25519

ดังนั้นหากเป็นไปได้ ก็แนะนำให้ Generate SSH Key โดยใช้ **ED25519**

*สามารถเข้าไปอ่านเพิ่มเติมได้ที่*
https://docs.hpc.gwdg.de/getting_started/connecting/ssh_faq/why_recommend_only_certain_key_types/index.html

https://medium.com/@sahil-awasthi/ed25519-or-rsa-which-one-is-better-18416fb51d0b

### Resources
- [คู่มือการสร้าง SSH Key](https://dtdreport.inet.co.th/index.php/s/XZTs9wCgK8tggWb)