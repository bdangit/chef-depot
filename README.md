# Habitat Depot

Cook up your own Private Habitat Depot.

    $ kitchen converge
    $ kitchen login
    vagrant@default-ubuntu-1604:~$ export SSL_CERT_FILE=$(hab pkg path core/cacerts)/ssl/cert.pem
    vagrant@default-ubuntu-1604:~$ sudo /bin/hab-director start -c /hab/etc/director/config.toml

## Credits

@jtimberman's private depot guide
https://gist.github.com/jtimberman/f939e9c822c581bc7168026f3fa4211c
