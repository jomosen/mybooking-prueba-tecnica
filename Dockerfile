# Dockerfile
ARG RUBY_VERSION=3.3.0
FROM ruby:${RUBY_VERSION}-slim

# paquetes necesarios para compilar gems y conectar a MariaDB/MySQL
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    tzdata \
    libmariadb-dev-compat \
    libmariadb-dev \
    libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

ARG BUNDLER_VERSION=2.5.3
RUN gem install bundler -v "$BUNDLER_VERSION"

ENV PATH="/usr/local/bundle/bin:${PATH}"

WORKDIR /app

# bundler más rápido y reproducible
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# instalar gems (cachea capa)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# copiar código
COPY . .

# puerto por defecto de rackup
EXPOSE 9292

# arranque por defecto (sinatra / rack)
CMD ["/usr/local/bundle/bin/rackup -o 0.0.0.0 -p 9292"]
