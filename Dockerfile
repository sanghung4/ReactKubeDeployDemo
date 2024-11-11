# Use node:19-alpine3.16 as the parent image for building the Docker image
FROM node:19-alpine3.16

# Install bash and curl, which is needed to install the Heroku CLI
RUN apk update && apk add bash curl

# Install the Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Create a working directory for Docker
WORKDIR /react-app

# Copy the React.js application dependencies from the package.json to the react-app working directory
COPY package.json .
COPY package-lock.json .

# Install all the React.js application dependencies
RUN npm install

# Copy the rest of the application files to the working directory
COPY . .

# Expose the React.js application container on port 3000
EXPOSE 3000

# The command to start the React.js application container
CMD ["npm", "start"]
