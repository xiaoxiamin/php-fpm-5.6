FROM centos:latest
RUN yum update && yum upgrade \
&& yum -y install gcc gcc-c++ autoconf automake libtool libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel gd gd-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers 
COPY libiconv-1.13.tar.gz /tmp
COPY libmcrypt-2.5.8.tar.gz /tmp
COPY mcrypt-2.6.8.tar.gz /tmp
COPY mhash-0.9.9.9.tar.gz /tmp
COPY php-5.6.19.tar.gz /tmp
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
	&& ./configure --prefix=/usr/local/php --with-config-file-path=/etc/php --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd  --with-iconv-dir=/usr/local --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --disable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-freetype-dir --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap=shared --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --enable-calendar --disable-phar \
	&& make ZEND_EXTRA_LIBS='-liconv' \
	&& make install \
&& ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib64 \
&& mkdir /etc/php \
&& cp php.ini-production /usr/local/php/etc/php.ini \
&& ln -s /usr/local/php/etc/php.ini /etc/php/php.ini \
&& cd /usr/local \
&& git clone git://github.com/phalcon/cphalcon.git \
&& cd cphalcon/build \
&& ./install \
&& cd /tmp && rm -rf \
libiconv-1.13.tar.gz libiconv-1.13 \
libmcrypt-2.5.8.tar.gz libmcrypt-2.5.8 \
mcrypt-2.6.8.tar.gz mcrypt-2.6.8 \
mhash-0.9.9.9.tar.gz mhash-0.9.9.9 \
php-5.6.19.tar.gz php-5.6.19 \
cphalcon \
&& echo extension=phalcon.so > /etc/php/php.ini \
&& sed -i 's/;extension_dir/extension_dir/g'\
&& sed -i 's/;date.timezone */date.timezone = PRC/'
VOLUME /etc/php/php.ini
