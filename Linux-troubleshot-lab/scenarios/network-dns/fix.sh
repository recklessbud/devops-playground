## fix dns resolution

    # check the /etc/resolve.conf file

    cat /etc/resolve.conf
    resolvectl status
    dig goole.com
    nslookup google.com

    # almost the same job for both dig and nslookup

    # now restore the original /etc/resolve.conf file

# fix a killed network interface
    ip a 
 
    sudo ip link set eth0 up

    ping google.com #to see if it works


# fix outbound DNS requests
    ss -tulnp
    iptables -L

    sudo iptables -F

# DNS service failure
    sudo systemctl start systemd-resolved
# and restart the OS



