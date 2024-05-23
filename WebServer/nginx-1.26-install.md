# How to install NGINX 1.26.0 (AlmaLinux9)

```bash
dnf install http://nginx.org/packages/rhel/9/x86_64/RPMS/nginx-1.26.0-1.el9.ngx.x86_64.rpm
```

# Generate DH Parameter
```bash
sudo openssl dhparam -out /etc/nginx/dh2048.pem 2048
```

# Generate Self signed certificate
```bash
sudo mkdir -p /etc/nginx/ssl

sudo openssl req -x509 -newkey rsa:4096 \
 -keyout /etc/nginx/ssl/nginx-selfsigned.key \
 -out /etc/nginx/ssl/nginx-selfsigned.crt \
 -sha256 -days 3650 -nodes \
 -subj "/C=TH/ST=Bangkok/L=Huaikwang/O=Internet Thailand PCL/OU=INET-SPA/CN=$(hostname)"
```

# Add default config `/etc/nginx/conf.d/000_default_http.conf`
```bash
# HTTP Server
server {
    listen          80 default_server;
    server_name     _;

    access_log      /var/log/nginx/default_http_access.log;
    error_log       /var/log/nginx/default_http_error.log;

    return 444;
}

# HTTPS Server
server {
    listen          443 ssl default_server;
    http2           on;
    server_name     _;

    access_log      /var/log/nginx/default_https_access.log;
    error_log       /var/log/nginx/default_https_error.log;

    # SSL Configuration
    ssl_certificate         /etc/nginx/ssl/nginx-selfsigned.crt;
    ssl_certificate_key     /etc/nginx/ssl/nginx-selfsigned.key;

    return 444;
}
```

# Add security header config `/etc/nginx/conf.d/001_security_header.conf`
```conf
# security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
```

# Setup nginx config `/etc/nginx/nginx.conf`
```conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

### Custom for performance ###
worker_rlimit_nofile 65535;
events {
    multi_accept on;
    worker_connections 65535;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$upstream_addr" "$request" '
                      '$status $request_length $body_bytes_sent $request_time "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   10;
    types_hash_max_size 2048;
    real_ip_header      X-Forwarded-For;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    ### Start custom ###

    # Cr. https://nginxconfig.io
    charset utf-8;
    server_tokens off;
    log_not_found off;
    client_max_body_size 128M;

    # Diffie-Hellman parameter for DHE ciphersuites
    ssl_dhparam /etc/nginx/dh2048.pem;

    # Mozilla Intermediate configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH:EDH:!NULL:!SSLv2:!RC4:!aNULL:!3DES:!IDEA:!SHA1:!SHA256:!SHA384;
    ssl_prefer_server_ciphers on;
    ssl_session_timeout 30m;
    ssl_session_cache shared:SSL:10m;
    ssl_buffer_size 8k;
    ssl_session_tickets off;
    
    # GZip configuration
    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/rss+xml application/atom+xml image/svg+xml font/woff2;

    # Support connection upgrade websocket
    map $http_upgrade $connection_upgrade {
      default upgrade;
      '' close;
    }

    ### End custom ###
}
```

# Unlock limit nofile `/etc/security/limit.conf`
```
# Allow max limit for nginx process user
nginx   soft    nofile  65535
nginx   hard    nofile  65535
nginx	soft	nproc	65535
nginx	hard	nproc	65535
```


# SELinux 
https://serverfault.com/questions/1145323/selinux-blocking-nginx-t

1. Check SELinux Audit Logs:
```
sudo ausearch -c 'nginx' --raw | audit2allow -M my-nginx-policy
sudo semodule -i my-nginx-policy.pp
```

2. Check Nginx Configuration Files:
```
sudo chcon -t httpd_config_t /etc/nginx/nginx.conf
```

3. Relabel the Entire Nginx Configuration Directory (if necessary):
```
sudo restorecon -Rv /etc/nginx/
```


# Add more vhost
```
# HTTP Server
server {
    listen          80;
    server_name     <server_name>;

    # enforce https
    location / {
        return  301 https://$server_name$request_uri;
    }
}

# HTTPS Server
server {
    listen          443 ssl;
    http2           on;
    server_name     <server_name>;

    access_log      /var/log/nginx/<name>_access.log main;
    error_log       /var/log/nginx/<name>_error.log;

    ssl_certificate             <cert_file>;
    ssl_certificate_key         <key_file>;

    # Example Websocket   
    #location /ws {
    #    proxy_pass                     http://127.0.0.1:8130;
    #    proxy_http_version     1.1;
    #    proxy_set_header Upgrade    $http_upgrade;
    #    proxy_set_header Connection "upgrade";

    #    proxy_set_header                Host $host;
    #    proxy_set_header                X-Real-IP $remote_addr;
    #    proxy_set_header                X-Forwarded-For $proxy_add_x_forwarded_for;
    #    proxy_set_header                X-Forwarded-Proto $scheme;
    #}

    # Example Proxy pass to backend
    #location / {
    #    proxy_pass                      http://127.0.0.1:8011;
    #    proxy_set_header                Host $host;
    #    proxy_set_header                X-Real-IP $remote_addr;
    #    proxy_set_header                X-Forwarded-For $proxy_add_x_forwarded_for;
    #    proxy_set_header                X-Forwarded-Proto $scheme;
    #}

    # Example config php-fpm
    #root    /var/www/html/wordpress;
    #index   index.html index.htm index.php;
    #location / {
    #    try_files $uri $uri/ /index.php$is_args$args;
    #}

    #location ~ \.php$ {
    #    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    #    fastcgi_pass unix:/var/run/php7.2-fpm-wordpress-site.sock;
    #    fastcgi_index index.php;
    #    include fastcgi.conf;
    #}
}
```