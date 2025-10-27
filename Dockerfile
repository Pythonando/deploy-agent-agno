FROM agnohq/python:3.12 AS base

ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_CACHE_DIR=/tmp/uv-cache UV_HTTP_TIMEOUT=120


ARG APP_USER=app
ARG APP_UID=10001
ARG APP_GID=10001
ARG APP_DIR=/app

ENV APP_USER=${APP_USER} APP_UID=${APP_UID} APP_GID=${APP_GID} APP_DIR=${APP_DIR}

RUN groupadd -g ${APP_GID} ${APP_USER} \
 && useradd -g ${APP_GID} -u ${APP_UID} -ms /bin/bash -d ${APP_DIR} ${APP_USER}


FROM base AS deps
WORKDIR ${APP_DIR}
COPY requirements.txt pyproject.toml ./
RUN uv pip sync requirements.txt --system && uv cache clean

FROM base AS production
WORKDIR ${APP_DIR}
COPY --from=deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=deps /usr/local/bin /usr/local/bin
COPY --chown=${APP_USER}:${APP_USER} . .
RUN sed -i 's/\r$//' /app/scripts/entrypoint.sh \
 && sed -i '1s/^\xEF\xBB\xBF//' /app/scripts/entrypoint.sh \
 && chmod 0755 /app/scripts/entrypoint.sh

USER ${APP_USER}
EXPOSE 8080
ENTRYPOINT ["bash", "/app/scripts/entrypoint.sh"]
