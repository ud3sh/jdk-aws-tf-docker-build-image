#TODO separate each RUNs stages into different images. i.e base-build, base-java-build, etc
FROM alpine:3.8

ENV LANG=C.UTF-8

#install base build tools
RUN apk add --no-cache \
        ca-certificates \
        bash \
        curl \
        gnupg \
        tar \
        git \
        openssh-client \
        openssl \
        gzip \
        parallel \
        net-tools \
        netcat-openbsd \
        unzip \
        zip \
        wget \
        dpkg \
        file \
        g++ \
        gcc \
        libtool \
        linux-headers \
        make \
        patch

#Install openJDK
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk JAVA_VERSION=8u181 JAVA_ALPINE_VERSION=8.181.13-r0
ENV PATH=$PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin
RUN set -x \
	&& apk add --no-cache \
		openjdk8=$JAVA_ALPINE_VERSION

#Install Maven
ENV MAVEN_VERSION=3.6.0 MAVEN_HOME=/usr/lib/mvn
ENV PATH=$PATH:$MAVEN_HOME/bin
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn


#Install pip3 and python 3 (see https://github.com/frol/docker-alpine-python3/blob/master/Dockerfile)
ENV PYTHON3_VERSION=3.6.6-r0
RUN apk add --no-cache python3=$PYTHON3_VERSION && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache


# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime


#USER circleci
CMD ["/bin/sh"]