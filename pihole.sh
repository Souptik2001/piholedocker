#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md

docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    -e TZ="America/Chicago" \
    -v "$(pwd)/etc-pihole/:/etc/pihole/" \
    -v "$(pwd)/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    pihole/pihole:latest

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        sudo docker exec -d pihole mkdir /home/network
	sudo docker cp blockdomains.sh pihole:/home/network/
	sudo docker cp unblockdomains.sh pihole:/home/network/
	sudo docker cp network.py pihole:/home/network/
	sudo docker exec -d pihole touch /home/network/log.txt
	sudo docker exec -d pihole sudo chmod u+x /home/network/blockdomains.sh
	sudo docker exec -d pihole sudo chmod u+x /home/network/unblockdomains.sh
	sudo docker exec -d pihole sudo chmod u+x /home/network/network.py
	sudo docker exec -d pihole sudo apt update
	sudo docker exec -d pihole sudo apt upgrade -y
	sudo docker exec -d pihole sudo apt-get install python3
	sudo docker exec -d pihole sudo apt install python3-pip
	sudo docker exec -d pihole pip3 install flask
	exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
