FROM nginx:1.23.0

RUN apt-get update && apt-get upgrade -y

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

RUN                                                                       \
  apt-get install -y                                                      \
  libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3    \
  libxss1 libasound2 libxtst6 xauth xvfb g++ make

WORKDIR /src/build-your-own-radar
COPY src/package.json ./
RUN npm install

COPY src/. ./

RUN touch /var/run/nginx.pid

#RUN ["chmod", "-R", "777", "/var/cache/nginx"]
RUN ["chown", "-R", "nginx", "/var/cache/nginx"]
RUN ["chown", "-R", "nginx", "/var/run/nginx.pid"]
RUN ["chmod", "+x", "build_nginx.sh"]
RUN ["chmod", "+x", "start_nginx.sh"]
ENV CLIENT_ID [Google Client ID]

EXPOSE 80

# Override parent node image's entrypoint script (/usr/local/bin/docker-entrypoint.sh),
# which tries to run CMD as a node command
#CMD ["./build_and_start_nginx.sh"]
RUN ./build_nginx.sh

USER nginx

ENTRYPOINT ["./start_nginx.sh"]
