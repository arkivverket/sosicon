FROM amd64/debian:buster-slim AS builder

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential

WORKDIR /sosicon

COPY src src

RUN pwd && mkdir -p bin/cmd/linux64

RUN make -C src

FROM amd64/debian:buster-slim

COPY --from=builder /sosicon/bin/cmd/linux64/sosicon /usr/bin/sosicon

ENTRYPOINT ["/usr/bin/sosicon"]

CMD ["-help"]
