# Docker_squid

## 目的 ： 使用docker創建squid代理伺服器，方便管理proxy，使爬蟲每一次request分配到不同的父代理上，避免被擋

## 流程 ：
1. 在apline上安裝squid,python及request套件
2. 透過python自動獲取多個proxy的ip及port，並更改squid設定檔
3. 在squid設定檔添加 never_direct allow all,讓所有request透過proxy出去

## 使用：

### build image

```
cd Docker_squid

docker build . -t squid

```

### run image
```
docker run -it -d --name squid_proxy -p 3128:3128 -e API_TOCKEN=yourtocken squid 

```

### test

* 每一次request，ip都會不同
```
curl -Lx http://127.0.0.1:3128 http://jsonip.com/
```
