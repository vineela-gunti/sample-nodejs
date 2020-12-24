FROM registry.redhat.io/ubi8/nodejs-12 AS base
ENV VERSION=psl-ubi-release-20201119
ENV BUILD_DATE='2020-11-19T00:00:00Z'
ENV RELEASE=psl-ubi-release-20201119

LABEL name="BigID Application" \
      maintainer="orena@bigid.com" \
      vendor="BigID INC" \
      version=$VERSION \
      release=$RELEASE \
      summary="BigID data scans create an Inventory of Personal Information (PI) found in your data sources and extracts data intelligence about your information stores." \
      buildDate=$BUILD_DATE \
      description="BigID data scans create an Inventory of Personal Information (PI) found in your data sources and extracts data intelligence about your information stored"
USER root
RUN mkdir /src
RUN mkdir /utils && mkdir /utils/signer && mkdir /utils/signer/prod
COPY package.json server.js /src/
RUN cd /src && npm install --unsafe-perm=true --allow-root

FROM registry.redhat.io/ubi8/nodejs-12
ENV VERSION=psl-ubi-release-20201119
ENV BUILD_DATE='2020-11-19T00:00:00Z'
ENV RELEASE=psl-ubi-release-20201119

LABEL name="BigID Application" \
      maintainer="orena@bigid.com" \
      vendor="BigID INC" \
      version=$VERSION \
      release=$RELEASE \
      summary="BigID data scans create an Inventory of Personal Information (PI) found in your data sources and extracts data intelligence about your information stores." \
      buildDate=$BUILD_DATE \
      description="BigID data scans create an Inventory of Personal Information (PI) found in your data sources and extracts data intelligence about your information stores."

USER root
RUN yum update -y && \
    yum install -y vim-minimal wget && \
    yum upgrade curl libexif-devel -y && \
    mkdir -m 775 /log && \
    chown 1001:0 /log
COPY --chown=1001 --from=base /src /src
RUN chgrp -R 0 /src && chmod -R g=u /src
WORKDIR /src

USER 1001
EXPOSE 8080
CMD npm start
