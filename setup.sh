#!/usr/bin/env bash

rm -rf laravel
git clone https://github.com/laravel/laravel
cd laravel || exit
git checkout 5.2
cp .env.example .env
php artisan key:generate
composer install --no-interaction
composer require --dev "$PACKAGE_NAME:dev-master"
composer require "phpunit/phpunit:^4.8 || ^5.0"

if [[ -v PACKAGE_PROVIDER ]]; then
    echo "$(awk '/'\''providers'\''[^\n]*?\[/ { print; print "'$(sed -e 's/\s*//g' <<<${PACKAGE_PROVIDER})',"; next }1' config/app.php)" > config/app.php
fi

if [[ -v FACADES ]]; then
    echo "$(awk '/'\''aliases'\''[^\n]*?\[/ { print; print "'$(sed -e 's/\s*//g' <<<${FACADES})',"; next }1' config/app.php)" > config/app.php
fi

cd .. || exit
