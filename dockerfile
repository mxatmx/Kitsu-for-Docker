FROM node:18-alpine as buildStage
WORKDIR /opt
# Install git to clone the repo
RUN apk add --no-cache git
ARG KITSU_VERSION
# Clone the repository
RUN git clone -b "${KITSU_VERSION}-build" --single-branch --depth 1 https://github.com/mxatmx/kitsu
# Build the application
WORKDIR /opt/kitsu
RUN npm install
RUN npm run build
# Production stage with nginx
FROM nginx:alpine
# Copy the built files from the build stage
COPY --from=buildStage /opt/kitsu/dist /opt/kitsu/dist
# Copy nginx configuration
COPY ./nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
