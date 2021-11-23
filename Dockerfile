FROM solr:8

USER root

## SOLR
ENV SOLR_HOST solr
ENV SOLR_PORT 8983
ENV SOLR_PATH /solr

LABEL org.label-schema.vendor="pantheon" \
  org.label-schema.name=$REPO_NAME \
  org.label-schema.description="Solr v8.8." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$VERSION \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/$REPO_NAME" \
  org.label-schema.usage="https://github.com/$REPO_NAME/blob/master/README.md#usage" \
  org.label-schema.docker.cmd="docker run --rm -v \$PWD:/work $REPO_NAME --parser=markdown --write '**/*.md'" \
  org.label-schema.schema-version="1.0"

WORKDIR /opt

RUN apt-get update && \
  apt-get install -y --fix-missing curl \
        git \
        procps \
        apt-utils \
        zip

RUN git clone https://git.drupalcode.org/project/search_api_solr.git \
  && cd search_api_solr \
  && git checkout -f 4.x

RUN cp /opt/docker-solr/scripts/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
EXPOSE 8983

USER solr

WORKDIR /opt/solr

ENTRYPOINT [ '/docker-entrypoint.sh' ]

CMD ['solr-fg']
