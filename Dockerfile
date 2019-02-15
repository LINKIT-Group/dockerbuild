FROM alpine as base

RUN apk update \
    && apk add --no-cache \
        bash

FROM scratch as user
COPY --from=base . .

ARG HOST_UID=${HOST_UID:-4000}
ARG HOST_USER=${HOST_USER:-nodummy}

RUN adduser -h /home/${HOST_USER} -D -u ${HOST_UID} ${HOST_USER} \
    && chown -R "${HOST_UID}:${HOST_UID}" /home/${HOST_USER}

USER ${HOST_USER}
WORKDIR /home/${HOST_USER}
