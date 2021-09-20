FROM amd64/debian:buster-slim

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential

WORKDIR /sosicon

COPY src src

RUN pwd && mkdir -p bin/cmd/linux64

RUN make -C src

RUN cp bin/cmd/linux64/sosicon /usr/bin/sosicon

RUN rm -rf /sosicon
