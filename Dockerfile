# Use a lightweight NGINX base image
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web app to NGINX public directory
COPY build/web /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the web server
EXPOSE 80

# Start nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]