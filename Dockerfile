FROM nginx:stable
RUN apt-get update && apt-get install -y ruby2.4 ruby-dev curl
# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
COPY nginx.conf /etc/nginx/
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
RUN curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent2.sh | sh
RUN /etc/init.d/td-agent restart
