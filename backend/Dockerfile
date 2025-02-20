# Use the official Node.js image as the base
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy only the required application files and folders
COPY index.js .
COPY models/ ./models/
# Expose the application port (match this to your app's port)
EXPOSE 3500

# Define environment variables to be used by the container
ENV DB_URL=default_value
ENV PORT=3500

# Start the application
CMD ["npm", "run", "start"]
