Ce fichier n'est que les résultats des commandes, pour les questions : un fichier existe.





PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker inspect web-vol1 --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

/web-vol1 - 172.17.0.2



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker inspect web-vol2 --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

/web-vol2 - 172.17.0.3



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> $ip\_web\_vol2 = docker inspect web-vol2 --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'



-> cree une instance ip\_web\_vol2 qui stockera le resultat pr le réutiliser derrière



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker exec web-vol1 ping -c 2 $ip\_web\_vol2

PING 172.17.0.3 (172.17.0.3) 56(84) bytes of data.

64 bytes from 172.17.0.3: icmp\_seq=1 ttl=64 time=0.142 ms

64 bytes from 172.17.0.3: icmp\_seq=2 ttl=64 time=0.214 ms



--- 172.17.0.3 ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1013ms

rtt min/avg/max/mdev = 0.142/0.178/0.214/0.036 ms



-> communique bien par l'instance ip\_web\_vol2



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker exec web-vol1 ping -c 2 8.8.8.8

PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.

64 bytes from 8.8.8.8: icmp\_seq=1 ttl=63 time=7.57 ms

64 bytes from 8.8.8.8: icmp\_seq=2 ttl=63 time=8.36 ms



--- 8.8.8.8 ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1002ms

rtt min/avg/max/mdev = 7.566/7.964/8.363/0.398 ms



-> comunique bien au réseau avec 8.8.8.8 (google)



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker network create tp2-network

d5e744d2edd70e0d2cacb1720b9b16ae07b608efcc7534bd723cffdc1747fb9b 



-> PID Du res.

PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker network ls | Select-String "tp2-network"



d5e744d2edd7   tp2-network   bridge    local



-> on a le pid, le nom, le type (ici un pont) et son scope



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker network inspect tp2-network | Select-String -Pattern "Subnet|Gateway"



&nbsp;                   "Subnet": "172.18.0.0/16",

&nbsp;                   "Gateway": "172.18.0.1"



-> sous reseau et la Gateway



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker run -d --name web-custom-net --network tp2-network custom-nginx

1d5b75faf6bdd1d9ac67e1b5f1f3f270a04b1a8cf8b572425cfa2ac65e1f8b5c



-> pid du nouveau service (1)



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker run -d --name web-custom-net2 --network tp2-network custom-nginx

24c1b7586cb108435725752d8e59b98e10c8f2b69871732898ed72281284a101



-> pid du second nouveau service (2)



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker exec web-custom-net ping -c 2 web-custom-net2

PING web-custom-net2 (172.18.0.3) 56(84) bytes of data.

64 bytes from web-custom-net2.tp2-network (172.18.0.3): icmp\_seq=1 ttl=64 time=0.183 ms

64 bytes from web-custom-net2.tp2-network (172.18.0.3): icmp\_seq=2 ttl=64 time=0.078 ms



--- web-custom-net2 ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1001ms

rtt min/avg/max/mdev = 0.078/0.130/0.183/0.052 ms



-> ici on voit que les 2 nouveaux services sont bien en communication, on passe par le DNS car automatique 



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker exec web-custom-net ping -c 2 web-custom-net2

PING web-custom-net2 (172.18.0.3) 56(84) bytes of data.

64 bytes from web-custom-net2.tp2-network (172.18.0.3): icmp\_seq=1 ttl=64 time=0.183 ms

64 bytes from web-custom-net2.tp2-network (172.18.0.3): icmp\_seq=2 ttl=64 time=0.078 ms



--- web-custom-net2 ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1001ms

rtt min/avg/max/mdev = 0.078/0.130/0.183/0.052 ms

PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker exec web-custom-net ip addr show

1: lo: <LOOPBACK,UP,LOWER\_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

&nbsp;   link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

&nbsp;   inet 127.0.0.1/8 scope host lo

&nbsp;      valid\_lft forever preferred\_lft forever

&nbsp;   inet6 ::1/128 scope host proto kernel\_lo

&nbsp;      valid\_lft forever preferred\_lft forever

2: eth0@if12: <BROADCAST,MULTICAST,UP,LOWER\_UP> mtu 1500 qdisc noqueue state UP group default

&nbsp;   link/ether 9e:47:1b:14:2d:e8 brd ff:ff:ff:ff:ff:ff link-netnsid 0

&nbsp;   inet 172.18.0.2/16 brd 172.18.255.255 scope global eth0

&nbsp;      valid\_lft forever preferred\_lft forever



-> toutes les infos du réseau







PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose ps

time="2026-02-10T16:51:37+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

NAME       IMAGE          COMMAND                  SERVICE   CREATED          STATUS          PORTS

tp2-test   alpine         "sh -c 'while true; …"   test      14 seconds ago   Up 13 seconds

tp2-web1   custom-nginx   "/docker-entrypoint.…"   web1      14 seconds ago   Up 13 seconds   0.0.0.0:8880->80/tcp, \[::]:8880->80/tcp

tp2-web2   custom-nginx   "/docker-entrypoint.…"   web2      14 seconds ago   Up 13 seconds   0.0.0.0:8881->80/tcp, \[::]:8881->80/tcp



on a cree une nouvelle infra alpine linux.



on show les logs (tres longues)



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose exec test ping -c 2 tp2-web1

time="2026-02-10T17:05:06+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

PING tp2-web1 (172.20.0.4): 56 data bytes

64 bytes from 172.20.0.4: seq=0 ttl=64 time=0.191 ms

64 bytes from 172.20.0.4: seq=1 ttl=64 time=0.374 ms



--- tp2-web1 ping statistics ---

2 packets transmitted, 2 packets received, 0% packet loss

round-trip min/avg/max = 0.191/0.282/0.374 ms



-> le web1 communique bien



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose exec test ping -c 2 tp2-web2

time="2026-02-10T17:05:45+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

PING tp2-web2 (172.20.0.3): 56 data bytes

64 bytes from 172.20.0.3: seq=0 ttl=64 time=0.189 ms

64 bytes from 172.20.0.3: seq=1 ttl=64 time=0.113 ms



--- tp2-web2 ping statistics ---

2 packets transmitted, 2 packets received, 0% packet loss

round-trip min/avg/max = 0.113/0.151/0.189 ms



-> le web2 communique bien



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose exec web1 ip addr show eth0

time="2026-02-10T17:06:14+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

2: eth0@if17: <BROADCAST,MULTICAST,UP,LOWER\_UP> mtu 1500 qdisc noqueue state UP group default

&nbsp;   link/ether 92:95:26:0d:27:e9 brd ff:ff:ff:ff:ff:ff link-netnsid 0

&nbsp;   inet 172.20.0.4/24 brd 172.20.0.255 scope global eth0

&nbsp;      valid\_lft forever preferred\_lft forever



-> permet de voir les IP du service 



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose down

time="2026-02-10T17:07:29+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

\[+] Running 4/4

&nbsp;✔ Container tp2-web2               Removed                                                                        1.0s

&nbsp;✔ Container tp2-web1               Removed                                                                        1.1s

&nbsp;✔ Container tp2-test               Removed                                                                       10.8s

&nbsp;✔ Network tp2-compose\_tp2-network  Removed  



-> tout est bien remove proporement 



-> Exo 4 : 



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose -f docker-compose-exercice.yaml exec monitor ping -c 2 app-frontend

time="2026-02-10T17:28:38+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose-exercice.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

PING app-frontend (10.10.1.2) 56(84) bytes of data.

64 bytes from app-frontend.tp2-exercice-final\_frontend-network (10.10.1.2): icmp\_seq=1 ttl=64 time=0.132 ms

64 bytes from app-frontend.tp2-exercice-final\_frontend-network (10.10.1.2): icmp\_seq=2 ttl=64 time=0.084 ms



--- app-frontend ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1001ms

rtt min/avg/max/mdev = 0.084/0.108/0.132/0.024 ms

PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker-compose -f docker-compose-exercice.yaml exec monitor ping -c 2 mysql-db

time="2026-02-10T17:28:47+01:00" level=warning msg="C:\\\\Users\\\\gmeurie\_belgium\\\\Docker\_Cours\\\\TP02\\\\docker-compose-exercice.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"

PING mysql-db (10.10.2.2) 56(84) bytes of data.

64 bytes from mysql-db.tp2-exercice-final\_backend-network (10.10.2.2): icmp\_seq=1 ttl=64 time=0.148 ms

64 bytes from mysql-db.tp2-exercice-final\_backend-network (10.10.2.2): icmp\_seq=2 ttl=64 time=0.082 ms



--- mysql-db ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1016ms

rtt min/avg/max/mdev = 0.082/0.115/0.148/0.033 ms 



-> les deux services communiquent bien : 0 packet de perdu 



Résultats :



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker ps -a --format "table {{.Names}}\\t{{.Status}}\\t{{.Ports}}"

NAMES               STATUS                           PORTS

container-b         Up 9 minutes                     80/tcp

container-c         Up 9 minutes                     80/tcp

container-a         Up 9 minutes                     80/tcp

network-monitor     Up 15 minutes

app-frontend        Up 4 minutes                     0.0.0.0:9000->80/tcp, \[::]:9000->80/tcp

mysql-db            Up 15 minutes                    3306/tcp, 33060/tcp

app-backend         Up 15 minutes                    80/tcp

web-custom-net2     Up 42 minutes                    80/tcp

web-custom-net      Up 43 minutes                    80/tcp

web-vol2            Up 54 minutes                    0.0.0.0:8081->80/tcp, \[::]:8081->80/tcp

web-vol1            Up 58 minutes                    0.0.0.0:8080->80/tcp, \[::]:8080->80/tcp

mon-serveur-web     Exited (255) About an hour ago   80/tcp

distracted\_kepler   Exited (255) About an hour ago





PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker volume ls --format "table {{.Name}}\\t{{.Driver}}"

VOLUME NAME                       DRIVER

exercice4-1\_volume1               local

exercice4-1\_volume2               local

mon-volume                        local

tp2-compose\_tp2-volume            local

tp2-exercice-final\_app-data       local

tp2-exercice-final\_backend-data   local

tp2-exercice-final\_mysql-data     local



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker network ls --format "table {{.Name}}\\t{{.Driver}}\\t{{.Scope}}"

NAME                                  DRIVER    SCOPE

bridge                                bridge    local

exercice4-1\_reseau1                   bridge    local

exercice4-1\_reseau2                   bridge    local

host                                  host      local

none                                  null      local

tp2-exercice-final\_backend-network    bridge    local

tp2-exercice-final\_frontend-network   bridge    local

tp2-network                           bridge    local



on verifie l'image en dernier :

PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker image inspect custom-nginx --format "{{.RepoTags}} - {{.Size}}"

\[custom-nginx:latest] - 65672090 





