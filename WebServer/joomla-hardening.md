# การ Hardening Joomla

เป็นการรวบรวมวิธีการ ปิดช่องโหว่ ที่อาจจะทำให้ระบบโดนโจมตีจากผู้ไม่หวังดี

1. Update Joomla Core & Extension
2. Remove Unused Templates & Extensions
3. Hide the Joomla Admin Panel
```
# .htaccess to hide admin panel from trusted ip
Order Deny, Allow
Deny from all
Allow from xx.xx.xx.xx
```
4. Secure Access Points
5. Enable Multi-Factor Authentication
6. Practice the Principle of Least Privilege
7. Use It or Lose It: Redux (Users)
8. Monitor Your Site
9. Maintain Joomla! Backups
10. Use HTTPS / SSL

```
# Redirect HTTP to HTTPS
RewriteEngine On RewriteCond %{HTTPS} off 
RewriteCond %{HTTP:X-Forwarded-Proto} !https 
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

11. Use a Joomla Web Application Firewall
12. Harden HTTP Security Headers

```
- Content-Security Policy
- X-XSS-Protection
- Strict-Transport-Security
- X-Frame-Options
- Public-Key-Pins
- X-Content-Type
```

13. Update PHP Version of your Joomla website or [PHP Hardening](./webserver-hardening.md)
14. Use Secure FTP Connections
15. Choose Smart Usernames and Passwords [Strong Password](../PasswordManagement/README.md)
16. Use a Joomla Security Extension

Cr.
- https://blog.sucuri.net/2022/10/how-to-secure-harden-your-joomla-website-in-12-steps.html
- https://magazine.joomla.org/all-issues/april-2021/best-practices-to-secure-your-joomla-website