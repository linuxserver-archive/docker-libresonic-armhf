FROM lsioarmhf/base.xenial
MAINTAINER sparklyballs

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIBRE_VER="v6.1.beta1"
ARG LIBRE_WWW="https://github.com/Libresonic/libresonic/releases/download"
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/config"
ARG JETTY_NAME=jetty-runner
ARG JETTY_VER="9.3.10.v20160621"
ARG JETTY_SRC="/tmp/jetty"
ARG JETTY_URL="https://repo.maven.apache.org/maven2/org/eclipse/jetty"
ARG JETTY_WWW="${JETTY_URL}"/"${JETTY_NAME}"/"${JETTY_VER}"/"${JETTY_NAME}"-"{$JETTY_VER}".jar

# copy prebuild files
COPY prebuilds/ /prebuilds/

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	ffmpeg \
	flac \
	lame \
	openjdk-8-jdk && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
/var/tmp/*

# install jetty-runner
RUN \
 mkdir -p \
	"${JETTY_SRC}" && \
 cp /prebuilds/* "${JETTY_SRC}"/ && \
 curl -o \
 "${JETTY_SRC}"/"$JETTY_NAME-$JETTY_VER".jar -L \
	"${JETTY_WWW}" && \
 cd "${JETTY_SRC}" && \
 install -m644 -D "$JETTY_NAME-$JETTY_VER.jar" \
	"/usr/share/java/$JETTY_NAME.jar" || return 1 && \
 install -m755 -D $JETTY_NAME "/usr/bin/$JETTY_NAME" && \
 rm -rf \
	/tmp/*

# install libresonic
RUN \
  mkdir -p \
	"${LIBRE_HOME}" && \
 curl -o \
 "${LIBRE_HOME}"/libresonic.war -L \
	"${LIBRE_WWW}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war


# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
