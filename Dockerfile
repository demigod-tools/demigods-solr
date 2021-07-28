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

WORKDIR /opt/solr

RUN apt-get update && \
  apt-get install -y --fix-missing make \
        supervisor \
        curl \
        git \
        vim \
        procps \
        apt-utils \
        zip \
        sudo

RUN mkdir -p /opt/solr
COPY demigods /opt/demigods
RUN chmod +x /opt/demigods/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/solr/data/configsets/drupal/conf
RUN git clone https://git.drupalcode.org/project/search_api_solr.git \
  && cd search_api_solr \
  && git checkout 4.x \
  && cp jump-start/solr8/config-set/* /var/solr/data/configsets/drupal/conf
COPY solrcore.properties /var/solr/data/configsets/drupal/conf
RUN echo "export PATH=/usr/local/openjdk-11:$PATH" >> /opt/solr/.bashrc
RUN chown solr:solr /opt/solr/.bashrc
RUN chmod +x /opt/solr/.bashrc
RUN chown -R solr:solr /var/solr/data/configsets

EXPOSE 8983

CMD [ "/usr/bin/supervisord" ]
