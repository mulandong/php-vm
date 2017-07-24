#!/bin/bash

# ===============================================

# install repo
sudo echo "======Install redis======"

sudo yum install -y redis
sudo systemctl start redis
sudo systemctl enable redis

sudo echo "======Install nodejs======"
sudo yum install -y nodejs

sudo echo "======Install less======"
cd /usr/lib/node_modules
sudo npm install less@1.7.5


sudo echo "======composer install php packages=========="
cd /letv/symfony/xserver-lecarx-admin
cp /vagrant/parameters.yml app/config/parameters.yml
composer install

sudo echo "====== 加载缓存 ======"
app/console cache:clear
app/console assetic:dump
