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
		imagemagick-dev graphicsmagick-dev fftw-dev zeromq-dev bash jemalloc-dev \
	&& \
	git clone https://github.com/torch/distro.git /usr/src/torch --recursive && \
	git clone --depth=1 --branch=v2.1 https://github.com/luajit/luajit && \
	cd /usr/src/torch && \
		sed -i 's/PREFIX=\$.*/PREFIX=\/torch/g' install.sh && \
		sed -i "s/\-DHAVE_MALLOC_USABLE_SIZE=1/\-DHAVE_MALLOC_USABLE_SIZE=0/" /usr/src/torch/pkg/torch/lib/TH/CMakeLists.txt && \
		mkdir /torch && \
		./install.sh && \
		ln -s /torch/bin/torch-activate /etc/profile.d/torch.sh && \
		ln -s /torch/bin/* /usr/bin/ && \
		ln -s /torch/lib/* /usr/lib && \
		ln -s /torch/include/* /usr/include && \
	cd /usr/src/luajit && \
		make PREFIX=/torch LDFLAGS="-ljemalloc" && \
		make PREFIX=/torch LDFLAGS="-ljemalloc" install && \
		ln -sf luajit-2.1.0-beta1 /torch/bin/luajit && \
		rm /torch/lib/libluajit.so && ln -s /torch/lib/libluajit-5.1.so /torch/lib/libluajit.so && \
		cp /torch/lib/pkgconfig/luajit.pc /usr/lib/pkgconfig && \
	cd / && \
	rm -rf /usr/src && \
	apk del --purge cmake perl && \
	rm -rf /var/cache/apk/*

# Lua Path and more.
env LUA_PATH '/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/torch/share/lua/5.1/?.lua;/torch/share/lua/5.1/?/init.lua;./?.lua;/torch/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
env LUA_CPATH '/root/.luarocks/lib/lua/5.1/?.so;/torch/lib/?.so;/torch/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'

CMD ["/torch/bin/luajit", "-ltorch"]
