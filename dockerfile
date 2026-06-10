FROM php:8.3-cli

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpq-dev

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer config -g process-timeout 2000

RUN composer install \
    --no-dev \
    --prefer-dist \
    --no-interaction \
    --optimize-autoloader

RUN chmod -R 777 storage bootstrap/cache

EXPOSE 10000


CMD ["sh", "-c", "php artisan storage:link || true && php artisan config:clear && php artisan route:clear && php artisan serve --host=0.0.0.0 --port=$PORT"]
