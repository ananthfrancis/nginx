FROM node:4
RUN apt-get update -y && \
	apt-get install -y \
	curl \
	build-essential \
	vim \
	libfile-which-perl \
	net-tools
RUN mkdir adminMongo 
WORKDIR adminMongo 
RUN npm i admin-mongo
CMD npm start
