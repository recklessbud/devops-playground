## Break the dns resolution

    # open the /etc/resolve.conf file and change the nameserver to a dummy

    # then ping to both google and 8.8.8.8 to see what works

    sudo nano /etc/resolve.conf

    ping 8.8.8.8
    ping google.com


## kill a network interface
    ip a 

    sudo ip link set eth0 down

    ip route 

    ping google.com #to see if it works

# ## block outbound DNS requests
    sudo iptables -A OUTPUT -j DROP


# DNS service failure
sudo systemctl stop systemd-resolved