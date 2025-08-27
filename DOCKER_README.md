# Docker Setup for Tools Engineer Blog

This repository includes Docker configuration to build and host the Jekyll static website.

## Quick Start

### Production Build & Serve

Build and run the production version of the site:

```bash
docker-compose up --build
```

The site will be available at http://localhost:8080

### Development Mode

For development with live reload:

```bash
docker-compose --profile dev up jekyll-dev
```

The development server will be available at http://localhost:4000 with live reload enabled.

## Manual Docker Commands

### Build the Docker Image

```bash
docker build -t tools-engineer-site .
```

### Run the Container

```bash
docker run -p 8080:80 tools-engineer-site
```

## Docker Image Details

The Docker image uses a multi-stage build process:

1. **Build Stage**: Uses Ruby 3.1 slim image
   - Installs system dependencies (build tools, git, curl)
   - Installs Node.js for gulp build process
   - Installs Ruby gems from Gemfile
   - Installs Node.js dependencies from package.json
   - Builds CSS assets using gulp
   - Builds the Jekyll site with `JEKYLL_ENV=production`

2. **Production Stage**: Uses nginx alpine image
   - Copies the built Jekyll site from the build stage
   - Configures nginx for optimal static file serving
   - Includes gzip compression and proper caching headers
   - Handles Jekyll pretty URLs

## Configuration Files

- `Dockerfile`: Multi-stage build configuration
- `docker-compose.yml`: Orchestration for both production and development
- `nginx.conf`: Nginx configuration optimized for Jekyll sites
- `.dockerignore`: Excludes unnecessary files from the build context

## Features

- **Production-ready**: Nginx with optimized configuration
- **Development support**: Live reload for development
- **Security headers**: Basic security headers included
- **Performance**: Gzip compression and cache headers
- **Pretty URLs**: Proper handling of Jekyll's pretty URLs

## Environment Variables

You can customize the build by setting environment variables:

```bash
# Example: Use a different base URL
docker build --build-arg JEKYLL_ENV=production -t tools-engineer-site .
```

## Troubleshooting

If you encounter issues:

1. Make sure Docker is running
2. Check that ports 8080 (production) or 4000 (development) are not in use
3. Try rebuilding without cache: `docker-compose build --no-cache`
4. Check logs: `docker-compose logs`
