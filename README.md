# Alpine-based Torch7 Dockerfile [![Build Status](https://travis-ci.org/vifino/docker-torch-alpine.svg?branch=master)](https://travis-ci.org/vifino/docker-torch-alpine)

Simple as that.

Builds [Torch](http://torch.ch) in a Docker container on Alpine basis.

Torch will be installed at `/torch`.

# Known Problems

The native libraries have a tendency to segfault.
For now there is no workaround.

Please look at [this issue at the Torch7 repo](https://github.com/torch/torch7/issues/549).

# LICENSE
MIT
