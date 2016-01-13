FROM axags/sbt-openshift

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

