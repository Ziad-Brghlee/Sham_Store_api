FROM php:8.3-apache

WORKDIR /var/www/html

COPY . .

RUN apt-get update && apt-get install -y \
    unzip git libzip-dev curl \
    && docker-php-ext-install pdo pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:cache

# خلي Apache يشتغل على public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

# صلاحيات Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]