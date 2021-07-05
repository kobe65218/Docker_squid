FROM alpine
# install python3 and squid
RUN apk add squid && apk add python3 && apk add py3-pip && pip install requests 

WORKDIR /file

# 將squid設定檔複製一份更改
RUN cp /etc/squid/squid.conf /etc/squid/squid.conf.original

# 修改讓所有網域都可以介入代理
RUN sed -i "s/http_access allow localhost/http_access allow all/"  /etc/squid/squid.conf.original
RUN sed -i "s/http_access deny all/#http_access deny all/" /etc/squid/squid.conf.original

#增加行設定 讓所有request都可以透過proxy 出去
RUN sed -i  "1a never_direct allow all" /etc/squid/squid.conf.original

#複製要執行的python檔
COPY change_squid_conf.py .  

#複製要執行的shell檔
COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

EXPOSE 3128

CMD ["./entrypoint.sh"]


