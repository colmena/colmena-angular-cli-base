# Base image
FROM node:7.7.2-alpine

# Set version numbers
ENV PM2_VERSION 2.4.2
ENV NPS_VERSION 5.0.4
ENV NGCLI_VERSION 1.0.0-rc.2
ENV PHANTOM_VERSION 2.11

# Install PhantomJS
RUN apk update && apk add --no-cache fontconfig curl && \
  mkdir -p /usr/share && \
  cd /usr/share \
  && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/${PHANTOM_VERSION}/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs \
  && phantomjs --version

# Install global packages
RUN npm install -g nps@${NPS_VERSION}
RUN npm install -g pm2@${PM2_VERSION}
RUN npm install -g @angular/cli@${NGCLI_VERSION}

# Add application folder
RUN mkdir /app
WORKDIR /app

# Add package.json and install deps
ADD package.json /app/package.json
RUN npm install @angular/cli@${NGCLI_VERSION}
RUN npm install && npm cache clean

# Expose the listening port
EXPOSE 4200

# Start the server
CMD ["npm", "run", "serve"]
