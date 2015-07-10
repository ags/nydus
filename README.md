nydus
-----

A tool for managing SSH tunnels.

## Usage

Given the file `tunnels.yml`:

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
```
