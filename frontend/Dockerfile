# First build stage
FROM node:18-alpine AS build_image
WORKDIR /home/app

COPY package.json .

RUN npm install

COPY . .

# This command builds the app and places the output in /home/app/build
RUN npm run build

EXPOSE 3000

# Second build stage
FROM node:16-alpine AS prod_build

WORKDIR /home/app

# Copy the build output from the previous stage
COPY --from=build_image /home/app/build/ /home/app/build/

COPY package.json .

RUN npm install -g serve

CMD ["serve", "-s", "build"]
