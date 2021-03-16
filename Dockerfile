FROM debian:latest

ENV LC_ALL C

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -yq \
        build-essential \
        curl \
        zlib1g \
        zlib1g-dev \
        zlibc \
        netcat \
	python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY Unreal3.2.8.1_backdoor.tar.gz /
RUN tar xzf Unreal3.2.8.1_backdoor.tar.gz \
     && cd /Unreal3.2.8.1 \
     && yes ""|./Config \
     && make \
     && mkdir -p /usr/lib64/unrealircd/modules \
     && cp -r src/modules/* /usr/lib64/unrealircd/modules

# Copy configuration files into place
COPY unrealircd-config /Unreal3.2.8.1/

EXPOSE 6667

ENTRYPOINT /Unreal3.2.8.1/unreal start | tail -f /dev/null
