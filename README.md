---

1. Copy those bash script to machine first. 
1. Replace place holder.
1. Enable these systemd services.


```
sudo cp service/* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ipset.service 
sudo systemctl enable load-ss-iptables-rules.service 
sudo systemctl enable nat.service 
```
