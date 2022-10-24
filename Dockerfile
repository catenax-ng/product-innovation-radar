FROM nginx:1.23.0

# Update docker container
RUN apt-get update

# Install node JS
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install dependencies
RUN                                                                       \
  apt-get install -y                                                      \
  libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3    \
  libxss1 libasound2 libxtst6 xauth xvfb g++ make

# NPM install
WORKDIR /src/build-your-own-radar
COPY src/package.json ./
RUN npm install

# Copy needed files
COPY src/. ./

# Add some needed info
ENV CLIENT_ID [Google Client ID]

# Authentication by user/password
RUN rm /etc/nginx/conf.d/*.conf
COPY httpauth/*.conf /etc/nginx/conf.d/
COPY httpauth/.htpasswd /src/
COPY error_page/ /src/


EXPOSE 80

# Build nginx platform
RUN chmod +x build_nginx.sh start_nginx.sh
RUN ./build_nginx.sh

# Run the app
ENTRYPOINT ["./start_nginx.sh"]
