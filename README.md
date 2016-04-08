# About this Repo

This repository is a **fork** of the [official image](https://docs.docker.com/docker-hub/official_repos/) for [php](https://registry.hub.docker.com/_/php/).
See [the Docker Hub page](https://registry.hub.docker.com/_/php/) for the full readme on how to use this Docker image.

This fork restores support for php-5.3 (not intended for production use), and adds a few "bundled" variations.

Though this fork is based on the official build, and strives to maintain compatibility with its workflow, it is in no
way part of the official Docker project, nor does it run any of the automated CI which the base project defines
configuration for.

The curl/ssl configuration for PHP 5.3 was copied from https://github.com/helderco/docker-php-5.3 This repository can
be seen as an integration between that repository and the official build.
