FROM solr:8
USER root
LABEL org.label-schema.vendor="pantheon" \
  org.label-schema.name=$REPO_NAME \
  org.label-schema.description="Solr v8.x." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$VERSION \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/$REPO_NAME" \
  org.label-schema.usage="https://github.com/$REPO_NAME/blob/master/README.md#usage" \
  org.label-schema.docker.cmd="docker run --rm -v \$PWD:/work $REPO_NAME --parser=markdown --write '**/*.md'" \
  org.label-schema.schema-version="1.0"

WORKDIR /opt

RUN apt-get update \
  && apt-get install -y --fix-missing curl \
        git \
        procps \
        apt-utils \
        zip \
        jq \
  && git clone https://git.drupalcode.org/project/search_api_solr.git \
  && cd search_api_solr \
  && git checkout -f 4.x \
  && curl -O https://versaweb.dl.sourceforge.net/project/lemur/lemur/RankLib-2.16/RankLib-2.16.jar \
  && ln -s RankLib-2.16.jar ranklib.jar \
  && cp /opt/docker-solr/scripts/docker-entrypoint.sh / \
  && chmod +x /docker-entrypoint.sh

COPY demigods/healthcheck.sh /
RUN chmod +x /healthcheck.sh

EXPOSE 8983

USER solr

WORKDIR /opt/solr

ENTRYPOINT [ 'docker-entrypoint.sh' ]

CMD ['solr-foreground']
