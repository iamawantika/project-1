# Use official Nginx image
FROM nginx:alpine

# Copy static files from src folder to nginx html directory
COPY src/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]