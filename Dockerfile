# pull official base image with Node
FROM node:13.12.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install --silent
RUN npm install react-scripts@3.4.1 -g --silent

# add app
COPY . ./

# environment setup for Node
ENV NODE_ENV development
ENV PORT 3000

EXPOSE 3000

RUN npm run start

# Main command
CMD [ "npm", "run", "start" ]
