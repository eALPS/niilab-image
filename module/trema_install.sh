#!/bin/bash
cd `dirname $0`
sudo apt update
sudo apt install ruby -y
sudo gem install trema
