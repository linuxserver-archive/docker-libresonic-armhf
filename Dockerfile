FROM lsiobase/alpine.armhf
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# copy prebuild and war files
COPY prebuilds/ /prebuilds/
COPY package/ /app/libresonic/

# package version settings
ARG JETTY_VER="9.3.14.v20161028"

# environment settings
ARG JETTY_NAME=jetty-runner
ARG JETTY_SRC="/tmp/jetty"
ARG JETTY_URL="https://repo.maven.apache.org/maven2/org/eclipse/jetty"
ARG JETTY_WWW="${JETTY_URL}"/"${JETTY_NAME}"/"${JETTY_VER}"/"${JETTY_NAME}"-"{$JETTY_VER}".jar
ARG LIBRE_URL="https://github.com/Libresonic/libresonic/releases/download"
ARG LIBRE_WWW="${LIBRE_URL}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/config"

# install packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \
 apk add --no-cache --virtual=build-dependencies \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	openjdk8 && \

# install jetty-runner
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

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# install runtime packages
RUN \
 apk add --no-cache \
	ffmpeg \
	flac \
	lame \
	ttf-dejavu && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	openjdk8-jre

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
