#!/bin/bash

sudo apt update
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctlenable apache2
echo “Hello from $(hostname -f).Created by USERDATA in Terraform. > /var/www/html/index.html

#If we browse the public address(with http, not https) of the instance then we will see "Hello from ...." message in browser
#If we ssh and connect to the instance and type "curl localhost" command in terminal, we will see same "Hello from ..." message

