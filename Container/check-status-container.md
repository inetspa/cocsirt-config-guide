## วิธีการตรวจสอบ Container ที่ใช้งานอยู่เบื้องต้น

#### วิธีการตรวจสอบเฉพาะ Container ที่ใช้งานอยู่เท่านั้น
เริ่มต้นโดยการใช้คำสั่ง `docker ps` เพื่อตรวจสอบสถานะ Containers ทั้งหมดที่ใช้งานอยู่ทั้งหมด
```
docker ps
```
ตัวอย่างผลลัพท์
```
$ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS                            PORTS                    NAMES
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   4 minutes ago   Up 4 minutes                      0.0.0.0:8080->8080/tcp   guacamole_frontend
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   4 minutes ago   Up 4 minutes (health: starting)   0.0.0.0:4822->4822/tcp   guacamole_backend
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes                      5432/tcp                 guacamole_database
```

#### วิธีการตรวจสอบ Container ทั้งหมด
รันคำสั่ง `docker ps -a` เพื่อตรวจสอบสถานะ Containers ที่ใช้งานและไม่ได้ใช้งานทั้งหมด
```
docker ps -a
```
ตัวอย่างผลลัพท์
```
$ docker ps -a
CONTAINER ID   IMAGE                        COMMAND                  CREATED              STATUS                          PORTS                    NAMES
0f368e6b6946   nginx:alpine                 "/docker-entrypoint.…"   About a minute ago   Exited (0) About a minute ago                            nginx-reverse-proxy
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   5 minutes ago        Up 5 minutes                    0.0.0.0:8080->8080/tcp   guacamole_frontend
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   5 minutes ago        Up 5 minutes (healthy)          0.0.0.0:4822->4822/tcp   guacamole_backend
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   5 minutes ago        Up 5 minutes                    5432/tcp                 guacamole_database
```

#### วิธีการตรวจสอบ Size ของ Containers ทั
รันคำสั่ง `docker ps -s` หรือกรณีที่ต้องการทุก Containers `docker ps -as` เพื่อตรวจสอบขนาดของ Containers ที่ใช้งาน
```
docker ps -s
```
หรือ 
```
docker ps -as
```
ตัวอย่างผลลัพท์
```
$ docker ps -s
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS                    PORTS                    NAMES                SIZE
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   19 minutes ago   Up 19 minutes             0.0.0.0:8080->8080/tcp   guacamole_frontend   19.5MB (virtual 518MB)
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   19 minutes ago   Up 19 minutes (healthy)   0.0.0.0:4822->4822/tcp   guacamole_backend    0B (virtual 149MB)
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   19 minutes ago   Up 19 minutes             5432/tcp                 guacamole_database   73B (virtual 351MB)
```
หรือ
```
$ docker ps -as
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS                      PORTS                    NAMES                 SIZE
0f368e6b6946   nginx:alpine                 "/docker-entrypoint.…"   15 minutes ago   Exited (0) 15 minutes ago                            nginx-reverse-proxy   1.09kB (virtual 43.4MB)
9833b6632434   guacamole/guacamole:latest   "/opt/guacamole/bin/…"   19 minutes ago   Up 19 minutes               0.0.0.0:8080->8080/tcp   guacamole_frontend    19.5MB (virtual 518MB)
e19123301f31   guacamole/guacd:latest       "/bin/sh -c '/opt/gu…"   19 minutes ago   Up 19 minutes (healthy)     0.0.0.0:4822->4822/tcp   guacamole_backend     0B (virtual 149MB)
75970a4f39f2   postgres:13.4                "docker-entrypoint.s…"   19 minutes ago   Up 19 minutes               5432/tcp                 guacamole_database    73B (virtual 351MB)
```