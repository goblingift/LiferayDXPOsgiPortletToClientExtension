FROM liferay/portal:7.4.3.120-ga120

ENV JAVA_VERSION=zulu11
ENV LIFERAY_JVM_OPTS="-Xms2048m -Xmx4096m"

USER root

RUN mkdir -p /opt/liferay/deploy && chown -R liferay:liferay /opt/liferay/deploy

COPY deploy/ /opt/liferay/deploy/

RUN chown -R liferay:liferay /opt/liferay/deploy && \
    find /opt/liferay/deploy -type d -exec chmod 775 {} \; && \
    find /opt/liferay/deploy -type f -exec chmod 664 {} \;

USER liferay