FROM nginx:stable
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y curl libcurl4-openssl-dev ruby ruby-dev make

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
COPY nginx.conf /etc/nginx/
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

# install fluentd td-agent
RUN curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent2.sh | sh

# install fluentd plugins
RUN /opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc \
    fluent-plugin-elasticsearch \
    fluent-plugin-record-modifier \
    fluent-plugin-exclude-filter


# add conf
ADD ./etc/fluentd /etc/fluentd

CMD /etc/init.d/td-agent stop && /opt/td-agent/embedded/bin/fluentd -c /etc/fluentd/fluent.conf
