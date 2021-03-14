FROM python:3.7-slim  
ARG APPUSER=appuser
RUN groupadd -r ${APPUSER} && useradd --no-log-init -r -g ${APPUSER} ${APPUSER}
RUN set -ex \
    && RUN_DEPS=" \
    libpcre3 \
    mime-support \
    default-libmysqlclient-dev" \
    && seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{} \
    && apt-get update && apt-get install -y --no-install-recommends $RUN_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt
COPY requirements.txt /requirements.txt
RUN set -ex \
    && BUILD_DEPS=" \
    build-essential \
    libpcre3-dev \
    libpq-dev" \
    && apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS \
    && pip install --no-cache-dir -r /requirements.txt \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt
WORKDIR /code/
COPY . /code/
EXPOSE 8000
ENV UWSGI_WSGI_FILE=devopstest/wsgi.py
ENV UWSGI_HTTP=:8000 UWSGI_MASTER=1 UWSGI_HTTP_AUTO_CHUNKED=1 UWSGI_HTTP_KEEPALIVE=1 UWSGI_LAZY_APPS=1 UWSGI_WSGI_ENV_BEHAVIOR=holy
ENV UWSGI_WORKERS=2 UWSGI_THREADS=4
ENV UWSGI_STATIC_MAP="/static/=/code/static/" UWSGI_STATIC_EXPIRES_URI="/static/.*\.[a-f0-9]{12,}\.(css|js|png|jpg|jpeg|gif|ico|woff|ttf|otf|svg|scss|map|txt) 315360000"
USER ${APPUSER}:${APPUSER}
ENTRYPOINT ["./entrypoint.sh"]
