Habitat Depot
=============

> Use at your own risk!

Cook up your own Private [Habitat](http://habitat.sh) Depot.

## Requirements

- Chef 12.11 or higher

## Platform Support

- Tested only on Ubuntu 16.04

## Setup

Place a dependency on the depot cookbook in your cookbook's metadata.rb.

```ruby
depends 'depot', '~> 0.2.0'
```

Then, in a recipe:

```ruby
include_recipe 'depot'
```

A service will be created as `hab-depot`.

## Attributes

|*name*|*default*|*description*|
|------|---------|-------------|
|`node['depot']['oauth']['client_id']`|`blah`| Client ID of your OAuth Application from GitHub|
|`node['depot']['oauth']['client_secret']`|`secret`| Client Secret of your OAuth Application from GitHub|
|`node['depot']['fqdn']`|`nil` (resolves to `node.name`)|Set this to whatever awesome name you want to give it like `my.awesome.depot.com`|

## Local Test

You can spin up a local Depot by using the included kitchen setup.

    $ kitchen converge

A vagrant box is spun up on 192.168.96.31 allowing you to view
http://192.168.96.31 in your browser.

## Usage

Once you have a depot provisioned. Here are some of the basics you should know
to make it useful.  In this setup, I will use 192.168.96.31 as the fqdn.

1. Sign-in to your private depot at http://192.168.96.31
2. From UI, Add your origin(s).
3. Upload your origin keys.
   ```
   $ hab origin key upload --url http://192.168.96.31/v1/depot nameoforigin
   $ hab origin key upload --url http://192.168.96.31/v1/depot --pubfile /path/to/somekey.pubfile
   ```

4. Upload your packages.
   ```
   $ hab pkg upload --url http://192.168.96.31/v1/depot somepackage.hart
   ```

### Tips

- You can set `HAB_DEPOT_URL` to `http://<fqdn>/v1/depot` and you won't have to
  keep passing `--url http://<fqdn>/v1/depot` in each command.
  
## Debug

```
$ systemctl status hab-depot
* hab-depot.service - Habitat Depot Server
   Loaded: loaded (/etc/systemd/system/hab-depot.service; static; vendor preset: enabled)
   Active: active (running) since Sat 2016-12-03 07:02:19 UTC; 8min ago
 Main PID: 2082 (hab-director)
    Tasks: 369
   Memory: 238.8M
      CPU: 25.838s
   CGroup: /system.slice/hab-depot.service
           |-2082 /bin/hab-director start -c /hab/etc/director/config.toml
           |-2085 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/builder-api-proxy --permanent-peer --bind router:
           |-2087 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/hab-builder-api --permanent-peer --bind database:
           |-2089 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/hab-builder-jobsrv --permanent-peer --bind databa
           |-2092 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/hab-builder-router --permanent-peer --listen-peer
           |-2094 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/hab-builder-sessionsrv --permanent-peer --bind da
           |-2096 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/hab-builder-vault --permanent-peer --bind databas
           |-2098 /hab/pkgs/core/hab-sup/0.13.1/20161115003952/bin/hab-sup start core/redis --permanent-peer --listen-peer 192.168.79.1
           |-2147 nginx: master process nginx -c /hab/svc/builder-api-proxy/config/nginx.con
           |-2150 nginx: worker process
           |-2151 nginx: cache manager process
           |-2184 bldr-session-srv start -c /hab/svc/hab-builder-sessionsrv/config.toml
           |-2214 bldr-router start -c /hab/svc/hab-builder-router/config.toml
           |-2244 bldr-vault start -c /hab/svc/hab-builder-vault/config.toml
           |-2284 bldr-api start -c /hab/svc/hab-builder-api/config.toml
           |-2315 redis-server *:6379
           `-2480 bldr-job-srv start -c /hab/svc/hab-builder-jobsrv/config.toml

Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Could not connect to any initi
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Joining gossip peer at 192.168
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Starting outbound gossip distr
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Starting gossip failure detect
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(CN): Starting census health adjuste
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(SV): Starting
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Listening for comman
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Listening for heartb
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Connecting to "tcp:/
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Connected

```

```
$ journalctl -u hab-depot.service -f
-- Logs begin at Sat 2016-12-03 06:58:09 UTC. --
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Could not connect to any initial peers; attempt 1 of 10.
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Joining gossip peer at 192.168.79.144:9001
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Starting outbound gossip distributor
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(GS): Starting gossip failure detector
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-sup(CN): Starting census health adjuster
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(SV): Starting
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Listening for commands on tcp://0.0.0.0:5566
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Listening for heartbeats on tcp://0.0.0.0:5567
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Connecting to "tcp://127.0.0.1:5563"...
Dec 03 07:03:24 default-ubuntu-1604 hab-director[2082]: core.hab-builder-jobsrv.private(O): hab-builder-jobsrv(O): Connected

```

## Credits

@jtimberman's private depot guide
https://gist.github.com/jtimberman/f939e9c822c581bc7168026f3fa4211c
