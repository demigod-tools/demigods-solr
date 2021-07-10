FROM solr:8

USER root

## SOLR
ENV SOLR_HOST solr
ENV SOLR_PORT 8983
ENV SOLR_PATH /

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

RUN apt-get update && \
  apt-get install -y --fix-missing make \
        supervisor \
        curl \
        vim \
        procps \
        apt-utils \
        zip \
        sudo

COPY init_solr /docker-entrypoint-initdb.d/
COPY actions.mk /usr/local/bin/actions.mk
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8983
WORKDIR /opt/solr

CMD [ "/usr/bin/supervisord" ]
