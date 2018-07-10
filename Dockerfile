FROM nginx:stable
RUN apt-get update && apt-get install -y ruby-dev curl git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
COPY nginx.conf /etc/nginx/
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN source ~/.bash_profile
RUN rvm install ruby-2.1.4
RUN rvm list
RUN rvm use --default ruby-2.1.4
