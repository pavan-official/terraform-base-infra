#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo apt install git -y
sudo git clone https://github.com/saikiranpi/SecOps-game.git
sudo rm -rf /var/www/html/*
sudo cp -r SecOps-game/index.html /var/www/html/
echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx