#!/bin/bash
base="$(dirname "${BASH_SOURCE[0]}")"

for version in \
	5.6 \
	7.0 \
	7.1 \
	7.2 \
	7.3
do
	for variant in \
		apache \
		fpm
	do
		tag="${version}-${variant}"
		mkdir -p "${base}/${tag}"
		echo "ARG PHP_VERSION=$version" > "${base}/${tag}/Dockerfile"
		echo "ARG PHP_VARIANT=$variant" >> "${base}/${tag}/Dockerfile"
		cat Dockerfile.tail >> "${base}/${tag}/Dockerfile"
	done
done
