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
    # Install md5sum if not included in build-essential
    apt-utils coreutils \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK 3.29.3
ENV FLUTTER_VERSION=3.29.3-stable
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN curl -SL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz \
    | tar -xJ -C /usr/local/ \
    && git config --global --add safe.directory /usr/local/flutter \
    && flutter config --no-analytics \
    && flutter doctor -v

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# Build the web release
RUN flutter build web --release

# --- Cache Busting Steps ---

# Fingerprint main.dart.js, rename it, and update flutter_bootstrap.js to use the new name
RUN MAIN_JS_HASH=$(md5sum build/web/main.dart.js | cut -c1-8) && \
    NEW_MAIN_JS_NAME="main.dart.${MAIN_JS_HASH}.js" && \
    echo "Renaming main.dart.js to ${NEW_MAIN_JS_NAME}" && \
    mv build/web/main.dart.js build/web/${NEW_MAIN_JS_NAME} && \
    echo "Updating flutter_bootstrap.js to reference ${NEW_MAIN_JS_NAME}" && \
    # This sed command attempts to replace the literal string 'main.dart.js'
    # in flutter_bootstrap.js with the new fingerprinted name.
    # It uses a slightly different delimiter for sed due to the dot in the filename.
    sed -i "s|main.dart.js|${NEW_MAIN_JS_NAME}|g" build/web/flutter_bootstrap.js


# Fingerprint flutter_bootstrap.js (after main.dart.js reference is updated)
# and update index.html to use it with a version query param
RUN BOOTSTRAP_HASH=$(md5sum build/web/flutter_bootstrap.js | cut -c1-8) && \
    NEW_BOOTSTRAP_NAME="flutter_bootstrap.${BOOTSTRAP_HASH}.js" && \
    echo "Renaming flutter_bootstrap.js to ${NEW_BOOTSTRAP_NAME}" && \
    mv build/web/flutter_bootstrap.js build/web/${NEW_BOOTSTRAP_NAME} && \
    echo "Updating index.html to reference ${NEW_BOOTSTRAP_NAME} with query param" && \
    # Update the index.html to reference the new flutter_bootstrap.js filename and add a version query param
    # Note: This assumes flutter_bootstrap.js is referenced directly without a query param initially in index.html
    sed -i "s|flutter_bootstrap.js|${NEW_BOOTSTRAP_NAME}?v=${BOOTSTRAP_HASH}|" build/web/index.html

# --- End Cache Busting Steps ---


# Stage 2: Serve with nginx
FROM nginx:stable-alpine

# Clean default content and copy build output
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build/web /usr/share/nginx/html

# Configure Nginx caching (Optional but Recommended)
# This example sets aggressive caching for fingerprinted files (assuming they have a hash in the name)
# and less aggressive/no-cache for index.html and the fingerprinted bootstrap file.
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port and start nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]