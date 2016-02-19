FROM sisk/kappa:1.0.0-rc.11

MAINTAINER Jean-Charles Sisk <jeancharles@paypal.com>

ENV CONSUL_TEMPLATE_VERSION=0.13.0

RUN apk add --update ca-certificates && \
    rm -rf /var/cache/apk/*

RUN ARCH=$(ARCH=$(apk --print-arch); case $ARCH in x86_64)ARCH=amd64;; x86)ARCH=386;; esac; echo $ARCH) \
    && wget -qO consul.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${ARCH}.zip \
    && unzip -d /usr/local/bin consul.zip consul-template \
    && rm consul.zip

RUN mkdir -p /data/consul-template/config.d /data/consul-template/template.d

COPY config/ /data/consul-template/config.d/
COPY templates/ /data/consul-template/template.d/

COPY entrypoint.sh /consul-template-entrypoint.sh
COPY restart-kappa.sh /restart-kappa.sh

RUN chmod +x /consul-template-entrypoint.sh /restart-kappa.sh

ENTRYPOINT ["/consul-template-entrypoint.sh"]

WORKDIR /data/consul-template

CMD ["consul-template"]
