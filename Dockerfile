FROM centos:latest
COPY aliyun-epel.repo /etc/yum.repo.d/aliyun-epel.repo
COPY aliyun-mirror.repo /etc/yum.repo.d/aliyun-mirror.repo
ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody
RUN mkdir -p $PHP_INI_DIR/conf.d \
&& yum update && yum upgrade \
&& yum -y install gcc unzip gcc-c++ git autoconf automake libtool libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel gd gd-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers 
COPY libiconv-1.13.tar.gz /tmp
COPY libmcrypt-2.5.8.tar.gz /tmp
COPY mcrypt-2.6.8.tar.gz /tmp
COPY mhash-0.9.9.9.tar.gz /tmp
COPY php-5.6.19.tar.gz /tmp
COPY cphalcon-master.zip /tmp
RUN cd /tmp \
	&& tar zxvf libiconv-1.13.tar.gz \
	&& tar zxvf libmcrypt-2.5.8.tar.gz \
	&& tar zxvf mhash-0.9.9.9.tar.gz \
	&& tar zxvf mcrypt-2.6.8.tar.gz \
	&& tar zxvf php-5.6.19.tar.gz \
	&& cd libiconv-1.13 \
	&& ./configure --prefix=/usr/local \
	&& make \
	&& make install \
	&& cd /tmp/libmcrypt-2.5.8 \
	&& ./configure \
	&& make \
	&& make install \
	&& /sbin/ldconfig \
	&& cd libltdl \
	&& ./configure --enable-ltdl-install \
	&& make \
	&& make install \
	&& cd /tmp/mhash-0.9.9.9 \
	&& ./configure \
	&& make \
	&& make install \
	&& ln -s /usr/local/lib/libmcrypt.la /usr/lib64/libmcrypt.la \
	&& ln -s /usr/local/lib/libmcrypt.so /usr/lib64/libmcrypt.so \
	&& ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib64/libmcrypt.so.4 \
	&& ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib64/libmcrypt.so.4.4.8 \
	&& ln -s /usr/local/lib/libmhash.a /usr/lib64/libmhash.a \
	&& ln -s /usr/local/lib/libmhash.la /usr/lib64/libmhash.la \
	&& ln -s /usr/local/lib/libmhash.so /usr/lib64/libmhash.so \
	&& ln -s /usr/local/lib/libmhash.so.2 /usr/lib64/libmhash.so.2 \
	&& ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1 \
	&& ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config \
  	&& cd /tmp/mcrypt-2.6.8 \
	&& /sbin/ldconfig \
	&& ./configure \
	&& make \
	&& make install \
	&& cp -frp /usr/lib64/libldap* /usr/lib/ \
	&& cd /tmp/php-5.6.19 \
	&& ./configure --prefix=/usr/local/php --with-config-file-path="$PHP_INI_DIR" --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd  --with-iconv-dir=/usr/local --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --disable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-freetype-dir --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap=shared --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --enable-calendar --disable-phar \
	&& make ZEND_EXTRA_LIBS='-liconv' \
	&& make install \
&& ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib64 \
&& ln -s /usr/local/php/bin/* /usr/local/bin \
&& ls /usr/local/php/etc/ && ls -l /tmp/php-5.6.19 \
#&& git clone git://github.com/phalcon/cphalcon.git \
&& cd /tmp && unzip cphalcon-master.zip \
&& cd cphalcon-master/build \
&& ./install \
&& ls -l /usr/local/php/etc/ && ls -l /tmp/php-5.6.19 \
&& cp /tmp/php-5.6.19/php.ini-production /usr/local/php/etc/php.ini \
&& cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
&& ls -l /usr/local/php/etc/ \
&& cd /tmp && rm -rf \
libiconv-1.13.tar.gz libiconv-1.13 \
libmcrypt-2.5.8.tar.gz libmcrypt-2.5.8 \
mcrypt-2.6.8.tar.gz mcrypt-2.6.8 \
mhash-0.9.9.9.tar.gz mhash-0.9.9.9 \
php-5.6.19.tar.gz php-5.6.19 \
cphalcon \
&& yum clean all \
#&& grep -v "^;" /etc/local/php/etc/php.ini \
#&& echo 'extension=phalcon.so'; > /usr/local/php/etc/php.ini \
#echo 'daemonize = no'; > /usr/local/php/etc/php.ini \
#echo 'listen = 127.0.0.1:9000'; > /usr/local/php/etc/php.ini \
#echo 'date.timezone = PRC'; > /usr/local/php/etc/php.ini \
#&& sed -i 's/;extension_dir/extension_dir/g' /usr/local/php/etc/php.ini \
#&& grep -v "^;" /usr/local/php/etc/php-fpm.conf \
#&& grep -v "^;" /usr/local/php/etc/php.ini
#&& { \
#	echo 'extension=phalcon.so' \
#	echo 'daemonize = no' \
#	echo 'listen = 127.0.0.1:9000' \
#	echo 'date.timezone = PRC' \
#	echo 'extensions_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226/"' \
# } | tee /usr/local/php/etc/php.ini 
&& cat /etc/local/php/etc/php.ini
VOLUME ["/usr/local/php/etc"]
CMD ["/usr/local/php/sbin/php-fpm"]
