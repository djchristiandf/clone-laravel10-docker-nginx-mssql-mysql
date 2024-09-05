FROM php:8.2-fpm-alpine

# Install necessary packages for SQL Server and ODBC
RUN apk add --no-cache \
  unixodbc-dev \
  freetds-dev \
  autoconf \
  g++ \
  make \
  curl \
  gnupg \
  && curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.5.1-1_amd64.apk \
  && apk add --allow-untrusted msodbcsql17_17.10.5.1-1_amd64.apk \
  && pecl install sqlsrv-5.11.0 pdo_sqlsrv-5.11.0 \
  && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Copy the PHP-FPM configuration
ADD ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Create a user and group for Laravel
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

# Create the necessary directory
RUN mkdir -p /var/www/html

# Set the permissions
RUN chmod -R 777 /var/www/html

# Copy the source code
ADD ./src/ /var/www/html

# Install any additional PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Set the ownership of the source code to the Laravel user
RUN chown -R laravel:laravel /var/www/html

# Set the permissions
RUN chmod -R 777 /var/www/html

# Switch to the Laravel user
USER laravel

# Default command (optional if not already set elsewhere)
CMD ["php-fpm"]
