docker-ve-server
================

This is a Docker container to run the Ve linguistics framework with its dependencies.

It currently only runs Mecab with Ipadic, but FreeLing English support is in the works.

Running
-------

```sh
$ docker build -t kimtaro/ve-server .
$ docker run -d -p :4567 -i kimtaro/ve-server
```
