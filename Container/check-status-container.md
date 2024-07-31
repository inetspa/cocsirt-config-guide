## วิธีการตรวจสอบสถานะ Container ที่ใช้งานอยู่

เริ่มต้นโดยการใช้คำสั่ง `docker ps` เพื่อตรวจสอบสถานะ Containers ทั้งหมดที่ใช้งานอยู่ทั้งหมด
```
# Docker
docker ps
```
ตัวอย่างผลลัพท์
```
# Docker
$ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS                            PORTS                    NAMES
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   4 minutes ago   Up 4 minutes                      0.0.0.0:8080->8080/tcp   guacamole_frontend
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   4 minutes ago   Up 4 minutes (health: starting)   0.0.0.0:4822->4822/tcp   guacamole_backend
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes                      5432/tcp                 guacamole_database
```

รันคำสั่ง `docker ps -a` เพื่อตรวจสอบสถานะ Containers ที่ใช้งานและไม่ได้ใช้งานทั้งหมด
```
# Docker
docker ps -a
```
ตัวอย่างผลลัพท์
```
# Docker
$ docker ps -a
CONTAINER ID   IMAGE                        COMMAND                  CREATED              STATUS                          PORTS                    NAMES
0f368e6b6946   nginx:alpine                 "/docker-entrypoint.…"   About a minute ago   Exited (0) About a minute ago                            nginx-reverse-proxy
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   5 minutes ago        Up 5 minutes                    0.0.0.0:8080->8080/tcp   guacamole_frontend
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   5 minutes ago        Up 5 minutes (healthy)          0.0.0.0:4822->4822/tcp   guacamole_backend
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   5 minutes ago        Up 5 minutes                    5432/tcp                 guacamole_database
```