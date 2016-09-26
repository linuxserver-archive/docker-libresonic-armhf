FROM lsiobase/xenial.armhf
MAINTAINER sparklyballs

# copy prebuild files
COPY prebuilds/ /prebuilds/

# package version settings
ARG JETTY_VER="9.3.10.v20160621"
ARG LIBRE_VER="v6.1.beta1"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/config"

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	ffmpeg \
	flac \
	lame \
	openjdk-8-jdk && \

# install jetty-runner
 mkdir -p \
	/tmp/jetty && \
 cp /prebuilds/* /tmp/jetty/ && \
 curl -o \
 /tmp/jetty/jetty.jar -L \
	"https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-runner/${JETTY_VER}/jetty-runner-{$JETTY_VER}.jar" && \
 cd /tmp/jetty && \
 install -m644 -D /tmp/jetty/jetty.jar \
	/usr/share/java/jetty-runner.jar || return 1 && \
 install -m755 -D jetty-runner \
	/usr/bin/jetty-runner && \

# install libresonic
  mkdir -p \
	"${LIBRE_HOME}" && \
 curl -o \
 "${LIBRE_HOME}"/libresonic.war -L \
	"https://github.com/Libresonic/libresonic/releases/download/${LIBRE_VER}/libresonic-${LIBRE_VER}.war" && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
