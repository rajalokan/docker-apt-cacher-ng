FROM ubuntu:xenial
MAINTAINER rajalokan@gmail.com

ENV APT_CACHER_NG_VERSION=0.9.1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng=${APT_CACHER_NG_VERSION}* \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/*

RUN echo "VfilePatternEx: \?((release=.*|arch=.*|repo=.*)&?)+|\/repodata\/.*xml" >>/etc/apt-cacher-ng/acng.conf
RUN echo "PfilePatternEX: \/RPM-GPG-KEY\/" >>/etc/apt-cacher-ng/acng.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apt-cacher-ng"]
