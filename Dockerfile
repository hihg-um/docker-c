# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE as builder

LABEL org.opencontainers.image.description="Base C/C++ container"

RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	git gcc g++ \
	make cmake \
	curl wget \
	software-properties-common
