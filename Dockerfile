FROM java:openjdk-8u72-jdk

ENV SBT_VERSION=0.13.9 \
    SBT_SHA1="879ee72d049f1718a29551f55590aa94972f4c96" \
    SBT_HOME=/opt/sbt \
    PATH=${PATH}:/opt/sbt/bin
    INVALIDATE_CACHE=true

# Download and unarchive SBT
RUN echo "Installing SBT ${SBT_VERSION} ..." \
  && curl -fsSLkv https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz -o /tmp/sbt.tgz \
  && echo "${SBT_SHA1}  /tmp/sbt.tgz" | sha1sum -c - \
  && tar -C /opt -xzf /tmp/sbt.tgz 

ENV APP_NAME=play-scala
ADD build.sbt /$APP_NAME/build.sbt
WORKDIR /$APP_NAME
ADD project/plugins.sbt project/plugins.sbt
ADD project/build.properties project/build.properties

RUN sbt update

ADD . .
RUN sbt -mem3000 stage
RUN chmod -R go+w target/universal/stage
WORKDIR target/universal/stage/bin

ADD start.sh ./
RUN chmod +x $APP_NAME && chmod +x start.sh

CMD ./start.sh

EXPOSE 9000

