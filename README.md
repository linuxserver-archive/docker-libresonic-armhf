[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# lsioarmhf/libresonic
[![](https://images.microbadger.com/badges/image/lsioarmhf/libresonic.svg)](https://microbadger.com/images/lsioarmhf/libresonic "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/lsioarmhf/libresonic.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/lsioarmhf/libresonic.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io-armhf/lsioarmhf-libresonic)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io-armhf/job/lsioarmhf-libresonic/)
[hub]: https://hub.docker.com/r/lsioarmhf/libresonic/


[Libresonic][libreurl] is a free, web-based media streamer, providing ubiqutious access to your music. Use it to share your music with friends, or to listen to your own music while at work. You can stream to multiple players simultaneously, for instance to one player in your kitchen and another in your living room.

[![libresonic](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/libresonic.png)][libreurl]
[libreurl]: https://github.com/Libresonic/libresonic

## Usage

```
docker create \
--name="libresonic" \
-v </path/to/config>:/config \
-v </path/to/music>:/music \
-e PGID=<gid> -e PUID=<uid> \
-e CONTEXT_PATH=<url-base> \
-e TZ=<timezone> \
-p 4040:4040 \
lsioarmhf/libresonic
```

**Parameters**

* `-p 4040` - the port(s)
* `-v /config` - Configuration file location
* `-v /music` - Location of music.
* `-e PGID` for for GroupID - see below for explanation - *optional*
* `-e PUID` for for UserID - see below for explanation - *optional*
* `-e CONTEXT_PATH` for setting url-base in reverse proxy setups - *optional*
* `-e TZ` for setting timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it libresonic /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
`IMPORTANT... THIS IS THE ARMHF VERSION`

Access WebUI at `<your-ip>:4040`.

Default user/pass is admin/admin

## Info

* To monitor the logs of the container in realtime `docker logs -f libresonic`.

## Version History

+ **26.09.16:** Inital Release

