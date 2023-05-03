FROM ubuntu:16.04 

ENV TERM=xterm\
    TZ=Europe/Istanbul

ENV DEBIAN_FRONTEND=noninteractive 

# http://nginx.org/en/download.html
ENV NGINX_VERSION 1.15.8

# https://github.com/openresty/headers-more-nginx-module/tags
ENV HEADERS_MORE_VERSION 0.33

# https://www.openssl.org/source
ENV OPENSSL_VERSION 1.0.1s

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    apt-transport-https curl rpcbind nfs-common openssh-client sshpass nano\
    bzip2 gnupg build-essential zlib1g-dev libperl-dev libgoogle-perftools-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libpcre3-dev libyaml-0-2 pkg-config libtool automake autoconf libyaml-dev libmcrypt-dev tzdata apt-utils librabbitmq-dev uuid-dev libgeoip-dev libgmp-dev libuv1-dev cmake  librdkafka-dev libmagickwand-dev g++ wget bsdtar libaio-dev libmosquitto-dev git-core --no-install-recommends && \
	  rm -rf /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && add-apt-repository -y ppa:jason.grammenos.agility/php \
    && apt-get update

RUN apt-get install -y php7.1-dev

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - &&  \
	curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list &&  \
	apt-get update && \
	ACCEPT_EULA=Y apt-get install -y --no-install-recommends gnupg msodbcsql17 &&  \
	ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools &&  \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
	apt-get install -y --no-install-recommends unixodbc-dev unixodbc libssl-dev


RUN apt-get install -y --no-install-recommends \
	unzip \	
	php7.1-pdo-dblib \
	php7.1-dev \
	php-pear \
	php7.1-fpm \ 
	php7.1-cli \ 
	php7.1-mbstring \ 
	php7.1-intl \ 
	php7.1-mysql \ 
	php7.1-redis \ 
	php7.1-memcached \ 
	php7.1-memcache \
	php7.1-gd \ 
	php7.1-curl \ 
	php7.1-xsl \ 
	php7.1-mongodb \ 
	php7.1-pgsql \ 
	php7.1-dev \
	php7.1-apcu \
	php7.1-common \
	php7.1-bz2 \
	php7.1-dba \ 
	php7.1-ssh2 \
	php7.1-solr \
	php7.1-apcu \
	php7.1-mailparse \
	php7.1-amqp \
	php7.1-geoip \
	php7.1-uuid \
	php7.1-imagick \
	php7.1-yaml \
	php7.1-odbc \  
	php7.1-soap \
	php7.1-zip 

#ENV LD_LIBRARY_PATH /usr/local/instantclient_11_2/

#RUN wget -qO- https://raw.githubusercontent.com/bumpx/oracle-instantclient/master/instantclient-basic-linux.x64-11.2.0.4.0.zip | bsdtar -xvf- -C /usr/local && \
#	wget -qO- https://raw.githubusercontent.com/bumpx/oracle-instantclient/master/instantclient-sdk-linux.x64-11.2.0.4.0.zip | bsdtar -xvf-  -C /usr/local && \
#	wget -qO- https://raw.githubusercontent.com/bumpx/oracle-instantclient/master/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip | bsdtar -xvf- -C /usr/local && \
#	ln -s /usr/local/instantclient_11_2 /usr/local/instantclient && \
#	ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so && \
#	ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
#	ldconfig && \
#	echo 'instantclient,/usr/local/instantclient' | pecl install oci8 && \
#	echo "extension = oci8.so" >> /etc/php/7.1/fpm/php.ini && \
#	echo "extension = oci8.so" >> /etc/php/7.1/cli/php.ini

#RUN wget -O - http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
#RUN echo "deb http://packages.couchbase.com/ubuntu bionic bionic/main" | tee /etc/apt/sources.list.d/couchbase.list

#RUN apt-get update && \
#  apt-get install -y --no-install-recommends libcouchbase-dev libcouchbase2-bin 

#RUN git clone https://github.com/datastax/cpp-driver.git cpp-driver && \
#	cd cpp-driver && \
#	git checkout -b tags/2.7.0 && \
#	mkdir build && \
#	cd build && \
#	cmake -DCASS_BUILD_STATIC=ON -DCASS_BUILD_SHARED=ON .. && \
#	make -j8 && \
#	make install


RUN mkdir -p /opt/oracle \
    && cd /opt/oracle \
    && wget https://github.com/hakanbaysal/docker-php-oci8/raw/master/instantclient-basic-linux.x64-12.1.0.2.0.zip \
    && wget https://github.com/hakanbaysal/docker-php-oci8/raw/master/instantclient-sdk-linux.x64-12.1.0.2.0.zip

# Install Oracle Instantclient
RUN unzip /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
    && unzip /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle
    
RUN ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so \
    && ln -s /opt/oracle/instantclient_12_1/libclntshcore.so.12.1 /opt/oracle/instantclient_12_1/libclntshcore.so \
    && ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/instantclient_12_1/libocci.so \
    && rm -rf /opt/oracle/*.zip

ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_12_1

# Install Oracle extensions
RUN echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8-2.2.0

RUN pecl install \
	pcs \
#	cassandra \	
#	couchbase \
	swoole \
#	rdkafka \
	timezonedb \ 
	sqlsrv-5.6.0 \
	pdo_sqlsrv-5.6.0 \
	pdo_oci8 \ 
	Mosquitto-0.4.0 

# 	echo -e "; priority=20\nextension=cassandra.so" > /etc/php/7.1/mods-available/cassandra.ini && \
RUN	echo -e "; priority=20\nextension=swoole.so" > /etc/php/7.1/mods-available/swoole.ini && \
	#echo -e "; priority=20\nextension=rdkafka.so" > /etc/php/7.1/mods-available/rdkafka.ini && \
	echo -e "; priority=20\nextension=timezonedb.so" > /etc/php/7.1/mods-available/timezonedb.ini && \
	echo -e "; priority=20\nextension=mosquitto.so" > /etc/php/7.1/mods-available/mosquitto.ini && \
	echo -e "; priority=20\nextension=pdo_sqlsrv.so" > /etc/php/7.1/mods-available/pdo_sqlsrv.ini && \
	echo -e "; priority=20\nextension=sqlsrv.so" > /etc/php/7.1/mods-available/sqlsrv.ini && \
	echo -e "; priority=20\nextension=oci8.so" > /etc/php/7.1/mods-available/oci8.ini 
# && \
#        echo -e "; priority=20\nextension=pdo_pgsql.so" > /etc/php/7.1/mods-available/pdo_pgsql.ini && \
#        echo -e "; priority=20\nextension=pdo_oci.so" > /etc/php/7.1/mods-available/pdo_oci.ini
#	echo "extension=couchbase.so" >> /etc/php/7.1/mods-available/json.ini

RUN phpenmod -v 7.1 -s ALL \
	pdo_dblib \
	mosquitto \
	solr \	
	ssh2 \
	#rdkafka \
	geoip \
	amqp \
	uuid \
	imagick \
	yaml \
	mbstring \ 
	intl \ 
	pdo_mysql \ 
	redis \ 
	memcached \ 
	memcache \ 
	gd \ 
	curl \ 
	xml \ 
	xsl \ 
	mongodb \ 
#	xdebug \ 
	sqlsrv \ 
	oci8 \ 
	pdo_sqlsrv \
	timezonedb \
	apcu \
#	cassandra \
	swoole \
	soap \
	zip

#RUN rm -rf /cpp-driver/

RUN useradd -r -s /usr/sbin/nologin nginx && mkdir -p /var/log/nginx /var/cache/nginx && \
echo "Downloading nginx v${NGINX_VERSION} from https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz ..." && wget -qO - https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar zxf - -C /tmp && \
	echo "Downloading headers-more v${HEADERS_MORE_VERSION} from https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz ..." && wget -qO - https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz | tar zxf - -C /tmp && \
	echo "Downloading openssl v${OPENSSL_VERSION} from https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz ..." && wget -qO - https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xzf  - -C /tmp && \
	echo "Installing libbrotli (latest) from https://github.com/bagder/libbrotli ..." && git clone https://github.com/bagder/libbrotli /tmp/libbrotli && cd /tmp/libbrotli && ./autogen.sh && ./configure && make && make install && \
    echo "Downloading ngx-brotli (latest) from https://github.com/google/ngx_brotli ..." && git clone --recursive https://github.com/google/ngx_brotli /tmp/ngx_brotli && \
	cd /tmp/nginx-${NGINX_VERSION} && \
	POSITION_AUX=true ./configure \
		--prefix=/etc/nginx  \
		--sbin-path=/usr/sbin/nginx  \
		--conf-path=/etc/nginx/nginx.conf  \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp  \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp  \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp  \
		--user=nginx  \
		--group=nginx  \
		--with-http_ssl_module  \
		--with-http_realip_module  \
		--with-http_addition_module  \
		--with-http_sub_module  \
		--with-http_dav_module  \
		--with-http_flv_module  \
		--with-http_mp4_module  \
		--with-http_gunzip_module  \
		--with-http_gzip_static_module  \
		--with-http_random_index_module  \
		--with-http_secure_link_module \
		--with-http_stub_status_module  \
		--with-http_auth_request_module  \
		--without-http_autoindex_module \
		--without-http_ssi_module \
		--with-threads  \
		--with-stream  \
		--with-stream_ssl_module  \
		--with-mail  \
		--with-mail_ssl_module  \
		--with-file-aio  \
		--with-http_v2_module \
		--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'  \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
		--with-ipv6 \
		--with-pcre-jit \
		--with-openssl=/tmp/openssl-${OPENSSL_VERSION} \--add-module=/tmp/ngx_brotli \
		--add-module=/tmp/headers-more-nginx-module-${HEADERS_MORE_VERSION} && \
	make -j8 && \
	make install && \
	apt-get purge -yqq automake autoconf libtool build-essential zlib1g-dev libpcre3-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev && \
	apt-get autoremove -yqq && \
	apt-get clean && \
	rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#RUN add-apt-repository universe
RUN apt-get update
RUN apt-get -y --no-install-recommends install supervisor && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get autoclean -y
RUN apt-get autoremove -y --purge

ADD conf/supervisord.conf /etc/supervisord.conf

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
mkdir -p /etc/nginx/sites-enabled/ && \
ln -sf /dev/stdout /var/log/nginx/access.log && \
ln -sf /dev/stderr /var/log/nginx/error.log && \
mkdir -p /etc/nginx/ssl/ && \
rm -Rf /var/www/* && \
rm -Rf /etc/nginx/sites-enabled/* 
ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
ADD conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Add Scripts
ADD scripts/start.sh /start.sh
ADD scripts/pull /usr/bin/pull
ADD scripts/push /usr/bin/push
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew && chmod 755 /start.sh
RUN mkdir -p -m 0777 /share

RUN apt-get update && apt-get install -y openssh-server iputils-ping net-tools
RUN mkdir /var/run/sshd
RUN echo 'root:123456' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile




# copy in code
ADD src/ /var/www/html/
ADD errors/ /var/www/errors


EXPOSE 443 80 22 9000
CMD ["/usr/sbin/sshd", "-D"]
CMD ["/start.sh"]
