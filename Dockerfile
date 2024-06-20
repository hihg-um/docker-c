# SPDX-License-Identifier: GPL-2.0
ARG BASE
FROM $BASE

RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	--no-install-recommends --no-install-suggests \
		ca-certificates \
		curl \
		gcc \
		g++ \
		wget \
	&& \
	apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/*

LABEL org.opencontainers.image.description="Base C/C++ container"
