# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE as builder

LABEL org.opencontainers.image.description="METAL software for meta analysis."

RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	cmake make \
  git zlib1g-dev

RUN git clone https://github.com/statgen/METAL.git

WORKDIR /METAL
RUN mkdir build && cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release .. && \
	make && \
	make test && \
	make install

FROM $BASE_IMAGE as runtime

ARG RUN_CMD

COPY --chmod=0555 --from=builder /METAL/build/bin/metal /usr/local/bin/

ARG TEST="/test.sh"
COPY --chmod=0555 src/test/$RUN_CMD.sh ${TEST}
