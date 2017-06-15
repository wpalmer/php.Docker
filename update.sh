#!/bin/bash
base="$(dirname "${BASH_SOURCE[0]}")"

for version in \
	5.6
do
	for variant in \
		apache \
		fpm
	do
		tag="${version}-${variant}"
		mkdir -p "${base}/${tag}"
		echo "FROM php:${tag}" > "${base}/${tag}/Dockerfile"
		cat Dockerfile.tail >> "${base}/${tag}/Dockerfile"
	done
done
