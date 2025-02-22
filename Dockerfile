FROM python:3.10.4-alpine AS builder

RUN apk add --update --no-cache gcc musl-dev libffi-dev openssl-dev make cargo
RUN pip install --no-cache-dir build
COPY . /src
RUN python -m build --wheel /src
RUN pip wheel --no-cache-dir /src/dist/*.whl --wheel-dir /tmp/wheels

FROM python:3.10.4-alpine

MAINTAINER 'Byeonghoon Isac Yoo <bh322yoo@gmail.com>'

COPY --from=builder /tmp/wheels/* /tmp/wheels/
RUN pip install /tmp/wheels/*.whl && rm -rf /tmp
RUN cd root && mkdir .ssh && chmod 700 .ssh && cd /root/.ssh  && touch authorized_keys && chmod 600 authorized_keys && cd ~

ENTRYPOINT ["/usr/local/bin/get_oracle_a1"]