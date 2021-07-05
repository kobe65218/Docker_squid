import requests
import os 

# 透過api取得代理伺服器ip和port

api_tocken = os.getenv("API_TOCKEN")
response = requests.get("https://proxy.webshare.io/api/proxy/list/", headers={"Authorization":api_tocken})
m = [[i["proxy_address"] , str(i["ports"]["http"])] for i in response.json()["results"]]

# 驗證是否有效
validips = []
for ip in m:
    try:
        res = requests.get('https://api.ipify.org?format=json',proxies = {'http':f"http://{ip[0]}:{ip[1]}", 'https':f"http://{ip[0]}:{ip[1]}"}, timeout = 5)
        validips.append({'ip':f"{ip[0]}:{ip[1]}"})
        print(res.json())
    except:
        print('FAIL', f"{ip[0]}:{ip[1]}")


# 將有效的proxy 寫入到squid 配置文件中
PEER_CONF = "cache_peer %s parent %s 0 no-query weighted-round-robin weight=1 connect-fail-limit=2 allow-miss max-conn=5\n"
def update_conf():
    with open("/etc/squid/squid.conf.original", "r") as F:
        squid_conf = F.readlines()
    squid_conf.append("\n# Cache peer config\n")
    for proxys in validips:
        proxy = proxys["ip"].strip().split(":")
        squid_conf.append(PEER_CONF % (proxy[0], proxy[1]))
    with open("/etc/squid/squid.conf", "w") as F:
        F.writelines(squid_conf)



if __name__ == "__main__":
   update_conf()






