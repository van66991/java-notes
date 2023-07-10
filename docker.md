新申请了一台阿里云的服务器，打算在上边部署一个容器服务，竟然发现机器上连docker都没安装。
解决

针对这个问题，今天特意记录了一下。我们就来看一下如何在linux服务器上安装docker。

第一步、更新yum包

```
yum update
```


第二步、安装依赖软件包

```
yum install -y yum-utils device-mapper-persistent-data lvm2
```

第三步、设置yum源

```
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

第四步、安装docker

```
yum install docker-ce 
```

备注：默认安装最新的docker稳定版本。

第五步、启动docker服务

```
systemctl start docker
```

第六步、设置开机自启动

```
systemctl enable docker 
```

我们可以使用 `docker version` 命令查看docker版本信息。






```
docker run --device /dev/net/tun --cap-add NET_ADMIN -ti -e PASSWORD=xxxx -v $HOME/.ecdata:/root -d -p 15901:5901 -p 11080:1080 --name easy hagb/docker-easyconnect:7.6.7
```

2. 以开放80端口为例：

开放端口：firewall-cmd --zone=public --add-port=80/tcp --permanent
重启防火墙：systemctl restart firewalld.service

查看已开启的端口信息：

firewall-cmd --list-ports

3. 防火墙常用命令：

查看防火墙状态，running代表正在运行：

firewall-cmd --state

停止命令

systemctl stop firewalld.service

启动命令

systemctl start firewalld.service

重启命令 

systemctl restart firewalld.service


要进入运行中的 Docker 容器，可以使用以下命令：

```bash
sudo docker exec -it ${CONTAINER-NAME} /bin/bash
```

其中，`CONTAINER-NAME` 是要进入的容器的名称。这个命令会在容器内启动一个新的终端会话，并将其连接到当前终端会话。在这个新的终端会话中，你可以像在本地机器上一样运行命令，查看容器内部的文件系统和运行状态。

在容器内部，你可以使用 `exit` 命令退出终端会话并返回到主机机器终端。注意，当退出容器终端会话时，并不会停止容器的运行。如果需要停止容器，可以使用 `docker stop` 命令。



要启动 Docker 容器，可以使用以下命令：

```bash
sudo docker start ${CONTAINER-NAME}
```

其中，`CONTAINER-NAME` 是要启动的容器的名称。这个命令会启动之前创建的、处于停止状态的容器。如果容器已经处于运行状态，这个命令不会起到任何作用。

需要注意的是，在使用 `docker run` 命令创建容器时，容器会自动启动。只有在使用 `docker stop` 命令将容器停止后，才需要使用 `docker start` 命令重新启动容器。





要查看正在运行中的 Docker 容器，可以使用以下命令：

```bash
sudo docker ps
```

这个命令会列出当前正在运行中的容器的基本信息，包括容器 ID、名称、使用的镜像、启动时间、运行状态等等。默认情况下，只会列出正在运行中的容器。如果要查看所有的容器，包括已经停止的容器，可以使用 `sudo docker ps -a` 命令。

如果想查看更详细的容器信息，可以使用 `sudo docker inspect CONTAINER-NAME` 命令，其中 `CONTAINER-NAME` 是要查看的容器的名称。这个命令会返回一个 JSON 格式的容器详细信息，包括容器的配置、网络设置、挂载的文件系统等等。





要删除服务器上的 Docker 容器，可以使用以下命令：

```bash
sudo docker rm ${CONTAINER-NAME}
```

其中，`CONTAINER-NAME` 是要删除的容器的名称或容器 ID。这个命令会删除指定的容器，如果容器正在运行中，需要先使用 `docker stop` 命令将其停止。



要停止一个正在运行的 Docker 容器，可以使用以下命令：

```bash
sudo docker stop ${CONTAINER-NAME}
```

其中，`CONTAINER-NAME` 是要停止的容器的名称或容器 ID。这个命令会向容器发送一个停止信号，然后容器会在适当的时候停止运行。如果容器已经停止了，这个命令不会起作用。





# docker封印深信服easyconnect

```
touch ~/.easyconn
```

```
ssh -L 1080:127.0.0.1:1080 -fN -D 1080 root@121.43.98.21
```

