# Stage 1: Build Flutter Web
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    build-essential \
    libgtk-3-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK 3.29.3
ENV FLUTTER_VERSION=3.29.3-stable
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN curl -SL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz \
    | tar -xJ -C /usr/local/ && \
    flutter config --no-analytics && \
    flutter doctor -v

# Copy application files and get dependencies\WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .

# Build the web release
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:stable-alpine

# Clean default content and copy build output
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port and start nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
