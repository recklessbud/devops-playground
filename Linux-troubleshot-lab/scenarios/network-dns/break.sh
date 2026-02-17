## Break the dns resolution

# open the /etc/resolve.conf file and change the nameserver to a dummy

# then ping to both google and 8.8.8.8 to see what works

sudo nano /etc/resolve.conf

ping 8.8.8.8
ping google.com