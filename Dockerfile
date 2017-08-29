FROM nginx
RUN apt-get update -y && \
	apt-get install -y \
	curl \
	build-essential \
	vim \
	libfile-which-perl \
	net-tools