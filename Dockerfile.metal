# SPDX-License-Identifier: GPL-2.0
ARG BASE
FROM $BASE as base
ARG BASE
ARG RUN_CMD

RUN apt -y update -qq && DEBIAN_FRONTEND=noninteractive apt -y install \
	--no-install-recommends --no-install-suggests \
		zlib1g \
	&& \
	apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/*

FROM base as builder

RUN apt -y update -qq && DEBIAN_FRONTEND=noninteractive apt -y install \
	--no-install-recommends --no-install-suggests \
		cmake \
		make \
		git \
		zlib1g-dev

WORKDIR /usr/src

RUN git clone https://github.com/statgen/${RUN_CMD}.git
RUN cd ${RUN_CMD} && mkdir build && cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release .. && make && \
	make test && make install

FROM base
ARG BASE
ARG RUN_CMD

COPY --chmod=0555 --from=builder /usr/src/${RUN_CMD}/build/bin/metal \
					/usr/local/bin/
COPY --chmod=0555 src/test/${RUN_CMD}.sh /test.sh

ENTRYPOINT [ "metal" ]

LABEL org.opencontainers.image.description="${RUN_CMD} software for meta analysis."
