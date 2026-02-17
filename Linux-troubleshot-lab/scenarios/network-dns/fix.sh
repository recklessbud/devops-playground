## fix dns resolution

    # check the /etc/resolve.conf file

cat /etc/resolve.conf
resolvectl status
dig goole.com
nslookup google.com

    # almost the same job for both

    # now restore the original /etc/resolve.conf file


