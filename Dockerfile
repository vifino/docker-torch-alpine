####################
# Torch Dockerfile #
#   Alpine-based   #
####################

FROM alpine

MAINTAINER Adrian "vifino" Pistol

RUN \
	echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk update && \
	apk upgrade && \
	apk add \
		alpine-sdk openblas-dev cmake curl readline-dev ncurses ncurses-dev wget \
		git gnuplot unzip libjpeg-turbo-dev libpng-dev gfortran perl openssl-dev \
		imagemagick-dev graphicsmagick-dev fftw-dev zeromq-dev bash \
	&& \
	git clone https://github.com/torch/distro.git /usr/src/torch --recursive && \
	cd /usr/src/torch && \
		sed -i 's/PREFIX=\$.*/PREFIX=\/torch/g' install.sh && \
		mkdir /torch && \
		./install.sh && \
		ln -s /torch/bin/torch-activate /etc/profile.d/torch && \
		ln -s /torch/bin/* /usr/bin/ && \
		ln -s /torch/lib/* /usr/lib && \
	apk del --purge cmake perl && \
	rm -rf /var/cache/apk/*

CMD ["/torch/bin/th"]
