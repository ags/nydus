nydus
-----

A tool for opening pre-configured SSH tunnels.

## Usage

Given the file `~/.nydus.yml`:

```
elasticsearch:
  port: 9200
  host: a.private.server.com
  hostport: 9200
  username: me
  hostname: a.public.bastion.com
```

```shell
$ nydus list
[elasticsearch] 9200:a.private.server.com:9200 me@a.public.bastion.com
$ nydus open elasticsearch
ssh -N -L 9200:a.private.server.com:9200 me@a.public.bastion.com
```
