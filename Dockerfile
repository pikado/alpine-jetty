FROM alpine:latest
MAINTAINER Pika Do <pokido99@gmail.com>

# Proxy settings if necessary
# ENV http_proxy=http://proxy:8080
# ENV https_proxy=http://proxy:8080
# ENV no_proxy="127.0.0.1,localhost,.mydomain.com"

# Upgrade system
RUN apk --no-cache upgrade

# Install Java
RUN apk --no-cache add openjdk8

# Install various tools
RUN apk --no-cache add curl

# Install Jetty
ENV JETTY_VERSION 9.3.8
ENV JETTY_RELEASE_DATE v20160314
ENV JETTY_HOME /usr/local/jetty
RUN curl -sO http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-${JETTY_VERSION}.${JETTY_RELEASE_DATE}.tar.gz && \
    tar -xzf jetty-distribution-${JETTY_VERSION}.${JETTY_RELEASE_DATE}.tar.gz -C /usr/local && \
    rm -f jetty-distribution-${JETTY_VERSION}.${JETTY_RELEASE_DATE}.tar.gz && \
    ln -s /usr/local/jetty-distribution-${JETTY_VERSION}.${JETTY_RELEASE_DATE} $JETTY_HOME

# Configure Jetty
ENV JETTY_USER jetty
RUN adduser -D $JETTY_USER && chown -R $JETTY_USER: $JETTY_HOME /usr/local/jetty-distribution-${JETTY_VERSION}.${JETTY_RELEASE_DATE}
USER $JETTY_USER
WORKDIR $JETTY_HOME

# Define default command
CMD ["java","-jar","start.jar"]
EXPOSE 8080
