# #First build stage
# FROM node:18-alpine AS build_image
# WORKDIR /home/app

# COPY package.json .

# # Increase memory limit for npm install
# RUN NODE_OPTIONS="--max-old-space-size=4096" npm install

# COPY . .

# # This command builds the app and places the output in /home/app/build
# RUN npm run build

# EXPOSE 3000

# # Second build stage
# FROM node:16-alpine AS prod_build

# WORKDIR /home/app

# # Copy the build output from the previous stage
# COPY --from=build_image /home/app/build/ /home/app/build/

# COPY package.json .

# RUN npm install -g serve

# CMD ["serve", "-s", "build"]









# First Stage: Build the React app
FROM node:18-alpine AS build_image

# Set the working directory
WORKDIR /home/app

# Copy only the package files to install dependencies
COPY package.json .

# Install dependencies
RUN npm install

# Copy only necessary application files
COPY public ./public
COPY src ./src

# Build the React app (output goes to /home/app/build)
RUN npm run build

# Second Stage: Serve the built app using Node.js
FROM node:18-alpine AS prod_image

# Set the working directory
WORKDIR /home/app

# Install serve globally to serve static files
RUN npm install -g serve

# Copy the build output from the build stage
COPY --from=build_image /home/app/build ./build

# Expose the application port
EXPOSE 3000

# Run the `serve` command to serve the static files
CMD ["serve", "-s", "build"]
