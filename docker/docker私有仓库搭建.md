# docker私有仓库

- 下载registry镜像并启动
```
docker pull registry
run  -itd -v  /data/registry:/var/lib/registry -p5000:5000 --restart=always --name registry registry

私有仓库默认是不支持删除，如果要支持删除功能，需要在启动时设置参数-e
docker run  -itd -v  /data/registry:/var/lib/registry -p5000:5000  -e REGISTRY_STORAGE_DELETE_ENABLED="true" --restart=always --name registry registry

测试,查看镜像仓库中所有的镜像
curl http://IP:5000/v2/_catalog
```

- 客户端镜像打包上传到私有仓库
```
1. 配置私有仓库信任
vim /etc/docker/daemon.json 
{
  "insecure-registries":["IP:5000"]
}
systemctl restart docker.service 

2. 打标签
docker  tag mysql:v1  IP:5000/mysql:v1

3. 上传
docker push IP:5000/mysql:v1

4. 下载
docker pull IP:5000/mysql:v1

5. 列出标签镜像
curl http://IP:5000/v2/mysql/tags/list
```

- 删除私有仓镜像
```
官方提供的registry镜像不支持删除,如下步骤可以变相删除
1. 获取Docker-Content-Digest
curl -H 'Accept:application/vnd.docker.distribution.manifest.v2+json'   -I -XGET http://47.91.210.14:5000/v2/mysql8.0/manifests/v1
如获取不到相关路径在:/data/registry/docker/registry/v2/repositories/mysql8.0/_manifests/tags/latest/index/sha256/

2. 删除记录,实际上并没有删除
curl -XDELETE 47.91.210.14:5000/v2/mysql8.0/manifests/sha256:f56b43e9913cef097f246d65119df4eda1d61670f7f2ab720831a01f66f6ff9c
查询记录
curl 47.91.210.14:5000/v2/mysql8.0/tags/list
{"name":"mysql8.0","tags":null}出现null说明记录删除了
3. 进入registry容器进行物理删除
registry garbage-collect /etc/docker/registry/config.yml
```