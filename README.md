# Setting up the server

- First create a server (proper port management should be done)
- Now first disable the internal dns server by executing `sudo systemctl stop systemd-resolved.service` and `sudo systemctl disable systemd-resolved.service`.
- Now as the dns is disabled the server will not be able to resolve any domain. So, to resolve this we change the `/etc/resolv.conf` file. There beside the `nameserver` word we add `8.8.8.8` which is the google dns.
- Now execute `git clone https://github.com/Souptik2001/piholedocker.git`. This will download a `piholedocker` named folder.
- Move to that directory and give executable permission to the pihole.sh file and then just run that file like `sudo pihole.sh`.
- And now your pihole server is ready and you can find it at `http://ip_addr` and log in using the auto password dispalyed at the last. To change this password enter into the container by executing `sudo docker exec -it pihole bash` and then execute `sudo pihole -a -p`.
- Now if you enter into the container and move to `/home/network` you will find a bunch of files. Now run `sudo python3 network.py`. Now you will get two apis `http://ip_addr:8080/block` and `http://ip_addr:8080/unblock` to block and unblock some sites. You can change the sites to be blocked and unblocked by changing the files `blockdomains.sh` and `unblockdomains.sh`.
- And that's it completly ready.

## Bonus

- You can take this thing one step further.
- First run this network.py in background by `sudo nohup python3 network.py > log.txt 2>&1 &`.
- And then you can use [IFTTT](https://ifttt.com/home) and trigger these two apis using any voice assistant like google assistant, alexa or anything.
- 🎉🔥
