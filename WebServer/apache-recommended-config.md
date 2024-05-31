# 0. Replace `/etc/httpd/conf/httpd.conf` ด้วย config ดังนี้
```apache
# Mod location
ServerRoot "/etc/httpd"
Include conf.modules.d/*.conf

# Exec user
User apache
Group apache

# Server defined
ServerAdmin root@localhost
#ServerName www.example.com:80

# Deny access to the entirety of your server's filesystem.
<Directory />
    AllowOverride none
    Require all denied
</Directory>

# Default access dir with index.html file
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

# Deny .ht* file
<Files ".ht*">
    Require all denied
</Files>

# Defined default error log location
ErrorLog "logs/error_log"

# Set log severity
# Possible values include: debug, info, notice, warn, error, crit,
# alert, emerg.
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      # You need to enable mod_logio.c to use %I and %O
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

# "/var/www/cgi-bin" should be changed to whatever your ScriptAliased
# CGI directory exists, if you have that configured.
<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>

EnableMMAP On
EnableSendfile on

# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

# 1. Default web config
สร้างไฟล์ `/etc/httpd/conf.d/000_default_web.conf` และเพิ่ม config
```apache
# Define global
Listen 80
Listen 443 https

# Index
DirectoryIndex index.php index.html

# Default สำหรับ HTTP และให้ redirect ไป domain หลัก หากไม่ match กับ vhost ไหนเลย
<VirtualHost _default_:80>
    Redirect / https://web-a.sdi.one.th
</VirtualHost>

# Default สำหรับ HTTPS และให้ redirect ไป domain หลัก หากไม่ match กับ vhost ไหนเลย
<VirtualHost _default_:443>
    Redirect / https://web-a.sdi.one.th
    # HTTPS
    SSLEngine On
    SSLCertificateFile /etc/ssl/nginx-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/nginx-selfsigned.key
</VirtualHost>

# Allow access directory
<Directory "/var/www/html">
    Options FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```
# 2. ปิด Server token ไม่ให้แสดง Version, HTTP Header และ HTTPS ที่แนะนำ
สร้างไฟล์ `/etc/httpd/conf.d/001_security.conf` และเพิ่ม Config เข้าไปดังนี้
```apache
# Hide version for security reason
ServerTokens Prod
ServerSignature Off

# Security Header
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-XSS-Protection "1; mode=block"
Header always set X-Content-Type-Options "nosniff"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"

<IfModule mod_ssl.c>
    # HTTPS Strength Config
    SSLProtocol -All +TLSv1.2 +TLSv1.3
    SSLHonorCipherOrder on
    SSLCompression      off
    SSLSessionTickets   off
    SSLCipherSuite EECDH:EDH:!NULL:!SSLv2:!RC4:!aNULL:!3DES:!IDEA:!SHA1:!SHA256:!SHA384
</IfModule>
```

# 3. เปิดใช้งาน gzip เพื่อเพิ่มประสิทธิภาพในการ Transfer web ถึง user ได้เร็วขึ้น
สร้างไฟล์ `/etc/httpd/conf.d/002_performance.conf` และเพิ่มเข้าไปดังนี้
```apache
<IfModule mod_ssl.c>
    # Enable HTTP/2
    Protocols h2 http/1.1
</IfModule>

# GZIP compression for text files: HTML, CSS, JS, Text, XML, fonts
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/vnd.ms-fontobject
    AddOutputFilterByType DEFLATE application/x-font
    AddOutputFilterByType DEFLATE application/x-font-opentype
    AddOutputFilterByType DEFLATE application/x-font-otf
    AddOutputFilterByType DEFLATE application/x-font-truetype
    AddOutputFilterByType DEFLATE application/x-font-ttf
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE font/opentype
    AddOutputFilterByType DEFLATE font/otf
    AddOutputFilterByType DEFLATE font/ttf
    AddOutputFilterByType DEFLATE image/svg+xml
    AddOutputFilterByType DEFLATE image/x-icon
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/javascript
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/xml
</IfModule>
```

# 4. เพิ่ม File config ให้รองรับ mod_php
เพิ่มไฟล์ `/etc/httpd/conf.d/003_mod_php.conf` และเพิ่ม php config
```apache
# The following lines prevent .user.ini files from being viewed by Web clients.
<Files ".user.ini">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
    <IfModule !mod_authz_core.c>
        Order allow,deny
        Deny from all
        Satisfy All
    </IfModule>
</Files>

# Allow php to handle Multiviews
AddType text/html .php

# mod_php options
<IfModule  mod_php7.c>
    # Cause the PHP interpreter to handle files with a .php extension.
    <FilesMatch \.(php|phar)$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # Apache specific PHP configuration options
    # those can be override in each configured vhost
    php_value session.save_handler "files"
    php_value session.save_path    "/var/lib/php/session"
    php_value soap.wsdl_cache_dir  "/var/lib/php/wsdlcache"
    php_value opcache.file_cache   "/var/lib/php/opcache"
</IfModule>

# Redirect to local php-fpm if mod_php (5 or 7) is not available
# สามารถใช้ External php-fpm ได้
<IfModule !mod_php5.c>
  <IfModule !mod_php7.c>
    # Enable http authorization headers
    SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1

    <FilesMatch \.(php|phar)$>
        SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost"
    </FilesMatch>
  </IfModule>
</IfModule>
```


# 5. เพิ่ม vHost ที่เราต้องการใช้งานดังตัวอย่าง Web-A และ Web-B
สร้างไฟล์ชื่อ `/etc/httpd/conf.d/101_web_a_one.conf` สำหรับเว็บ https://web-a.sdi.one.th
```apache
# Redirect to https
<VirtualHost *:80>
    ServerName web-a.sdi.one.th
    Redirect / https://web-a.sdi.one.th
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot "/var/www/html/web-a"
    ServerName web-a.sdi.one.th

    # Default webroot
    <Directory "/var/www/html/web-a">
        Options FollowSymLinks
        Require all granted
    </Directory>

    # HTTPS
    SSLEngine On
    SSLCertificateFile /etc/ssl/nginx-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/nginx-selfsigned.key
    # Attach Intermediate cert
    #SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt

    # Custom log location
    ErrorLog logs/web_a_error.log
    CustomLog logs/web_a_access.log combined
</VirtualHost>
```


สร้างไฟล์ชื่อ `/etc/httpd/conf.d/102_web_b_one.conf` สำหรับเว็บ https://web-b.sdi.one.th
```apache
# Redirect to https
<VirtualHost *:80>
    ServerName web-b.sdi.one.th
    Redirect / https://web-b.sdi.one.th
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot "/var/www/html/web-b"
    ServerName web-b.sdi.one.th

    # Default webroot
    <Directory "/var/www/html/web-b">
        Options FollowSymLinks
        Require all granted
    </Directory>

    # Subdirectory of web A in other location
    # Alias "<web_path>" "<directory>"
    Alias "/subweb" "/var/www/html/subweb-a"

    # HTTPS
    SSLEngine On
    SSLCertificateFile /etc/ssl/nginx-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/nginx-selfsigned.key
    #SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt

    # Custom log location
    ErrorLog logs/web_b_error.log
    CustomLog logs/web_b_access.log combined
</VirtualHost>
```
