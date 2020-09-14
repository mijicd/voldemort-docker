FROM adoptopenjdk:8-jdk-hotspot-bionic AS builder

ARG VOLDEMORT_VERSION=release-1.10.26-cutoff

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://github.com/voldemort/voldemort/archive/$VOLDEMORT_VERSION.zip && \
    unzip $VOLDEMORT_VERSION.zip && \
    mv voldemort-* voldemort && \
    cd /voldemort && \
    ./gradlew clean build -x test

FROM adoptopenjdk:8-jre-hotspot-bionic
COPY --from=builder /voldemort .
EXPOSE 6666 6667 8081

ENTRYPOINT ["bin/voldemort-server.sh"]
CMD ["config/single_node_cluster"]
