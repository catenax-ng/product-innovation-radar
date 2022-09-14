FROM nginx:1.23.0

RUN apt-get update && apt-get upgrade -y

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

RUN                                                                       \
  apt-get install -y                                                      \
  libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3    \
  libxss1 libasound2 libxtst6 xauth xvfb g++ make


RUN chmod 777 /opt
RUN chmod 777 /etc
RUN chmod 777 /var

WORKDIR /src/build-your-own-radar
COPY src/package.json ./
RUN npm install

COPY src/. ./

RUN chmod 777 /src
RUN ["chmod", "+x", "build_and_start_nginx.sh"]

ENV CLIENT_ID [Google Client ID]

# Override parent node image's entrypoint script (/usr/local/bin/docker-entrypoint.sh),
# which tries to run CMD as a node command
CMD ["./build_and_start_nginx.sh"]
