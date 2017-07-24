#!/bin/bash

# ===============================================

# install repo
sudo echo "======Install repo======"

sudo yum install -y epel-release

cd /vagrant/downloads

if [ ! -e "remi-release-7.rpm" ]; then
  curl -O http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
fi
sudo rpm -Uvh remi-release-7*.rpm
sudo cp /vagrant/remi.repo /etc/yum.repos.d/  # enable remi-php56

if [ ! -e "mysql57-community-release-el7-9.noarch.rpm" ]; then
  curl -O http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
fi
sudo yum localinstall -y mysql57-community-release-el7-9.noarch.rpm

sudo echo "Show repo list:"
sudo yum repolist enabled

sudo echo "Update repo:"
sudo yum update -y

# ===============================================

# install tools
sudo echo "======Install tools======"
sudo yum install -y git
sudo yum install -y vim

# ===============================================

# install php 5.6.30
sudo echo "======Install php 5.6.30======"
sudo yum install -y php php-pear \
  php-opcache \
  php-intl \
  php-gd \
  php-mysql \
  php-mcrypt \
  php-fpm \
  php-bcmath \
  php-mbstring \
  php-redis \
  php-soap \
  php-ssh2 \
  php-swoole \
  php-xml \
  php-pecl-xdebug \
  php-pecl-apcu
sudo systemctl enable php-fpm

# install mysql
sudo echo "======Install mysql======"
sudo yum install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# install nginx
sudo echo "======Install nginx======"
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo echo "======Install redis======"
sudo yum install -y redis
sudo systemctl start redis
sudo systemctl enable redis

sudo echo "======Install nodejs======"
sudo yum install -y nodejs

sudo echo "======Install less======"
cd /usr/lib/node_modules
sudo npm install less@1.7.5

# install other tools
sudo yum install -y composer
sudo yum install -y phpunit


# ===============================================

# config nginx
sudo cp /vagrant/nginx.conf /etc/nginx/
sudo nginx -s reload

# config php
sudo sed -i -e 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php.ini  # set timezone
sudo sed -i -e 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php.ini  # set memory_limit

# ===============================================

# copy php-info.php to default nginx website root
sudo cp /vagrant/php-info.php /usr/share/nginx/html/


# ===============================================

# search the initialized password of mysql root user and show it in console
sudo echo "===The initialized password of mysql root user==="
sudo grep "password" /var/log/mysqld.log
