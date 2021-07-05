FROM alpine
RUN apk add squid &&apk add python3 && apk add py3-pip && pip install requests 
WORKDIR /file
RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.original
RUN sed -i "s/http_access allow localhost/http_access allow all/"  /etc/squid/squid.conf.original
RUN sed -i "s/http_access deny all/#http_access deny all/" /etc/squid/squid.conf.original
RUN sed -i  "1a never_direct allow all" /etc/squid/squid.conf.original
COPY change_squid_conf.py .  
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
EXPOSE 3128
CMD ["./entrypoint.sh"]


