#!/bin/sh
DOMAINS='owncloud.joict.nl monitoring.joict.nl joict.nl www.joict.nl owncloud.jorisdejosselindejong.nl monitoring.jorisdejosselindejong.nl www.jorisdejosselindejong.nl'
SUBUNTU="iptables -t nat -I PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.178.101:80 &&
iptables -t nat -I PREROUTING -p tcp --dport 443 -j DNAT --to 192.168.178.101:443 &&
iptables -t nat -I PREROUTING -p udp --dport 80 -j DNAT --to 192.168.178.101:80 &&
iptables -t nat -I PREROUTING -p udp --dport 443 -j DNAT --to 192.168.178.101:443"

SROUTER="iptables -t nat -I PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.178.1:80 &&
iptables -t nat -I PREROUTING -p tcp --dport 443 -j DNAT --to 192.168.178.1:443 &&
iptables -t nat -I PREROUTING -p udp --dport 80 -j DNAT --to 192.168.178.1:80 &&
iptables -t nat -I PREROUTING -p udp --dport 443 -j DNAT --to 192.168.178.1:443"


for DOMAIN in $DOMAINS
do
  sudo certbot certonly --noninteractive --nginx -d $DOMAIN
  if [ $? -eq 0 ]; then
    echo succesfully made certificates
    scp -r /etc/letsencrypt/live/$DOMAIN root@192.168.178.1:/opt/etc/nginx/certs/$DOMAIN
    echo moved $DOMAIN to router
    MAKESSL="touch /opt/etc/nginx/sites-enabled/ssl-$DOMAIN.conf && echo -e 'ssl_certificate /opt/etc/nginx/certs/$DOMAIN/fullchain.pem;\nssl_certificate_key /opt/etc/nginx/certs/$DOMAIN/privkey.pem;' > /opt/etc/nginx/sites-enabled/ssl-$DOMAIN.conf && /opt/etc/init.d/S80nginx restart"
    ssh root@192.168.178.1 $MAKESSL
  fi
done

wget -q --spider google.com
if [ $? -eq 0 ]; then
    echo wget working no need to reboot router
  else
    echo wget not working reboot of router needed
fi

