FROM node:0.10

COPY bootstrap /usr/share/nginx/html

ENV NGINX_VERSION 1.9.12-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

ADD ./run_doc.sh /opt/run_doc.sh

RUN chmod 755 /opt/run_doc.sh

CMD ["/opt/run_doc.sh"]