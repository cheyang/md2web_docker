FROM nginx:1.8.1

COPY bootstrap /usr/share/nginx/html

RUN apt-get install -y nodejs \
				       npm && \
	npm install -g markdown2bootstrap

ADD ./run_doc.sh /opt/run_doc.sh
RUN chmod 755 /opt/run_doc.sh

CMD ["/opt/run_doc.sh"]