# Centos 7 - Development Environment

This image install add systemd, httpd 2.4, supervisord
- Support start httpd apache by system service or supervisord

### Build systemd base image

```
$ docker build -t centos7-stack .
```

### Running a systemd enabled app container

```
$ docker run -ti --privileged=true --name devstack -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 8080:80 centos7-stack /bin/bash
```

or

```
$ docker-compose up --build
```

### Testing

Go to http://localhost:8080

### Note

- If you want to start Apache with Supervisord > Uncomment this file `/etc/supervisord/conf.d/httpd.conf` and comment `systemctl enable httpd.service` line in `Dockerfile`.
