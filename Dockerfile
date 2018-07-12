FROM nginx:stable
RUN apt-get update && apt-get -y upgrade
RUN apt-get update -y && apt-get install -yy \
      build-essential \
      zlib1g-dev \
      ruby-dev \
      rubygems \
      libjemalloc1 && \
    gem install fluentd && \
    fluent-gem install fluent-plugin-mongo

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
COPY nginx.conf /etc/nginx/
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN mkdir -p /var/log/fluent
COPY fluentd.conf /etc/fluent/fluentd.conf
# port monitor forward debug
EXPOSE 24220   24224   24230
RUN COPY access.log /tmp/access.log

ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
CMD ["fluentd", "-c", "/etc/fluent/fluentd.conf"]
