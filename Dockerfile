# from docker hub - node.js image

FROM node:8

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND port-listener.json are copied
COPY p*.json ./

# If you are building your code for production
# RUN npm install --only=production
RUN npm install

# Bundle app source
# COPY . .

# App binds to port
EXPOSE 8080

# Command to run your app using CMD which defines the runtime. Here we will use the basic npm start which will run port-listener.js and start the app
CMD [ "npm", "start" ]