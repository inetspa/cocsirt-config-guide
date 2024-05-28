## วิธีการติดตั้งและใช้งาน Container

Container Engine จะมีด้วยกันหลักๆ ให้ใช้งานคือ [Docker](https://www.docker.com/) และ [Podman](https://podman.io/)
การทำงานก็จะเหมือนกัน ใช้งาน Resource เหมือนกัน แต่ในที่นี้เราจะแนะนำให้ใช้ docker

### การ Install Docker และใช้งาน Docker

ใน Debian, Ubuntu จะมี Install script ของ `Docker` ให้ใช้งานติดตั้งได้โดย
```
# Run install script
sudo curl -sS https://get.docker.com | sudo sh -

# Enable & start docker service
sudo systemctl start docker
sudo systemctl enable docker
```

แต่ใน AlmaLinux, Rocky Linux ตัว Install จะไม่รองรับ จะต้องใช้การ Add repository และ install เอง
```
# Add docker repository
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# Install docker engine
sudo dnf install docker-ce

# Enable & start docker service
sudo systemctl start docker
sudo systemctl enable docker
```

หลังจาก Install เสร็จแล้วเราสามารถใช้คำสั่ง
```
# เพื่อตรวจสอบ Version ของ docker ได้ 
sudo docker version

# เพื่อดู Container ที่กำลัง ทำงานอยู่
sudo docker ps
```

### ทดสอบ Start nginx ที่เป็น Container

เริ่มโดยการสั่ง Run เพื่อทดสอบ nginx

```
# Docker
docker run --rm -p 80:80 --name nginx nginx:alpine
```

หลังจาก start แล้วก็ลองเปิด Browser และเข้าเว็บด้วย Port 80

### การใช้งานไฟล์ `docker-compose.yml`

ไฟล์ `docker-compose.yml` ก็จะเป็นไฟล์ config สำหรับ run container service โดยจะมีรูปแบบดังนี้

ตัวอย่าง ไฟล์ `docker-compose.yml` สำหรับ run database mysql version 5.7
```yaml
services:
  mysql:
    image: mysql:5.7
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    ports:
      - "3306:3306"
    volumes:
      - ./mysql-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=db
      - MYSQL_USER=user
      - MYSQL_PASSWORD=password
      - MYSQL_ROOT_PASSWORD=secret
```

หลังจาก ใส่ไฟล์เสร็จ ก็ทำการ start container
```
# Docker
sudo docker compose up -d
```

### ตัวอย่างการ run wordpress ด้วย container

1. เริ่มต้นก็สร้าง dir ของ wordpress ไว้ที่ `/opt/docker/wordpress`
```
# สร้าง Dir
sudo mkdir -p /opt/docker/wordpress

# เข้าไปที่ Dir ที่สร้างไว้
cd /opt/docker/wordpress
``` 

2. สร้างไฟล์ `docker-compose.yml` และเพิ่ม config ของ wordpress และ database ลงไป
```yaml
services:
  mysql:
    image: mysql:8.0
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    volumes:
      - ./mysql-data:/var/lib/mysql
    environment:
      MYSQL_DATABASE: db
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: secret
  wordpress:
    image: wordpress
    restart: always
    ports:
      - "8080:80"
    volumes:
      - ./wordpress-data:/var/www/html
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: db
    depends_on:
      - mysql
```

3. หลังจากสร้างไฟล์เสร็จ ก็รันคำสั่ง
```
sudo docker compose up -d
```

4. รอสักครู่ เพื่อให้ database start เสร็จสมบูรณ์ ก็จะสามารถเปิดหน้าเว็บ ```http://127.0.0.1:8080``` ก็จะเริ่มเข้าใจงาน wordpress ได้แล้ว อย่างง่ายดาย

![Wordpress](assets/wordpress-docker.png)