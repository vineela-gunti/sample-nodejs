FROM registry.redhat.io/ubi8/nodejs-12 AS base
ENV VERSION=psl-ubi-release-20201119
ENV BUILD_DATE='2020-11-19T00:00:00Z'
ENV RELEASE=psl-ubi-release-20201119

LABEL name="Bhim Application" \
      maintainer="test@bhim.com" \
      vendor="Bhim INC" \
      version=$VERSION \
      release=$RELEASE \
      summary="BHIM is an initiative to enable fast, secure, reliable cashless payments through your mobile phone. " \
      buildDate=$BUILD_DATE \
      description="BHIM is an Indian mobile payment App developed by the National Payments Corporation of India, based on the Unified Payments Interface."
USER root

#Create src and utils directory 
RUN mkdir /src /utils
#copy contents of utils directory
COPY utils/ /utils
#copy application source code to src
COPY package.json app.js /src/
#install node modules
RUN cd /src && npm install --unsafe-perm=true --allow-root

FROM registry.redhat.io/ubi8/nodejs-12
ENV VERSION=psl-ubi-release-20201119
ENV BUILD_DATE='2020-11-19T00:00:00Z'
ENV RELEASE=psl-ubi-release-20201119

LABEL name="Bhim Application" \
      maintainer="test@bhim.com" \
      vendor="Bhim INC" \
      version=$VERSION \
      release=$RELEASE \
      summary="BHIM is an initiative to enable fast, secure, reliable cashless payments through your mobile phone." \
      buildDate=$BUILD_DATE \
      description="BHIM is an Indian mobile payment App developed by the National Payments Corporation of India, based on the Unified Payments Interface."

USER root
RUN yum update -y && \
    yum install -y vim-minimal wget && \
    yum upgrade curl libexif-devel -y && \
    mkdir -m 775 /log && \
    chown 1001:0 /log
    
#copy utils and src from base image    
COPY --chown=1001 --from=base /utils /utils
COPY --chown=1001 --from=base /src /src
RUN chgrp -R 0 /src && chmod -R g=u /src
WORKDIR /src

USER 1001
EXPOSE 8080
CMD npm start
