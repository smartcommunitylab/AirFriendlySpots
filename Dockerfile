FROM node:lts-alpine AS build

RUN apk --no-cache add python3 build-base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:lts-alpine
ARG VER=0.1.0
ARG USER=airfriendlyspots
ARG USER_ID=1500
ARG USER_GROUP=airfriendlyspots
ARG USER_GROUP_ID=1500
ARG USER_HOME=/home/${USER}

# create a user group and a user
RUN  addgroup -g ${USER_GROUP_ID} ${USER_GROUP}; \
     adduser -u ${USER_ID} -D -g '' -h ${USER_HOME} -G ${USER_GROUP} ${USER} ;

WORKDIR /app
COPY --from=build /app/dist /app/dist

RUN npm install -g http-server vue

EXPOSE 8080
USER airfriendlyspots
ENTRYPOINT [ "http-server", "dist" ]
