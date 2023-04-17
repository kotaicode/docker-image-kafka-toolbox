FROM ubuntu:22.04

ENV KAFKA_VERSION=2.8.1
ENV KAFKA_URL=https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz
ENV KAFKA_TMP_DEST=/opt/kafka.tgz
ENV KAFKA_WORKDIR=/opt/kafka

# hadolint ignore=DL3008
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  software-properties-common \
  python3 python3-pip \
  dnsutils net-tools \
  curl traceroute tcpdump httpie \
  jq \
  htop \
  wget \ 
  default-jdk \ 
  ant \
  unzip \
  ca-certificates-java && \ 
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  update-ca-certificates -f;

RUN wget -nv "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install

RUN wget -nv $KAFKA_URL -O ${KAFKA_TMP_DEST} && \
    mkdir -p ${KAFKA_WORKDIR} && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR}
RUN wget -nv https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar -P ${KAFKA_WORKDIR}/libs

COPY client.properties ${KAFKA_WORKDIR}/bin

WORKDIR /opt/kafka

