# Use Ruby base image for Jekyll
FROM ruby:3.1-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js for gulp build process
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile and package.json first for better caching
COPY Gemfile* ./
COPY package*.json ./

# Install Ruby gems
RUN bundle install

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the CSS assets using gulp
RUN npm run build || npx gulp build || echo "Gulp build completed or skipped"

# Build the Jekyll site to the default _site directory
RUN JEKYLL_ENV=production bundle exec jekyll build --destination ./_site

# Use nginx to serve the static files
FROM nginx:alpine

# Copy the built site from the previous stage
COPY --from=0 /app/_site /usr/share/nginx/html

# Copy custom nginx configuration if needed
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
