#!/bin/sh

# For Ubuntu or Debian-based Linux distributions
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update
    sudo apt-get install build-essential curl file git python-setuptools ruby
fi

# For CentOS based Linux distributions
if [ -x "$(command -v yum)" ]; then
    sudo yum groupinstall 'Development Tools' && sudo yum install curl file git irb python-setuptools ruby
fi

# Install Linuxbrew
if [ $(dpkg-query -W -f='${Status}' brew 2>/dev/null | grep -c "brew is already installed") -eq 0 ]; then
    # clone git repo
	git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew

	# set system variables
    PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$(brew --prefix)/share/man:$MANPATH"
    export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
	
	# check brew dependencies
	brew doctor
fi

# Install NodeJS and dependencies

if [ $(dpkg-query -W -f='${Status}' libimobiledevice 2>/dev/null | grep -c "libimobiledevice is already installed") -eq 0 ]; then
	brew install libimobiledevice --HEAD
fi

if [ $(dpkg-query -W -f='${Status}' carthage 2>/dev/null | grep -c "carthage is already installed") -eq 0 ]; then
	brew install carthage
fi

if [ $(dpkg-query -W -f='${Status}' node 2>/dev/null | grep -c "node is already installed") -eq 0 ]; then
	brew install node
fi

# Install Appium and dependencies 
if [ $(dpkg-query -W -f='${Status}' appium 2>/dev/null | grep -c "appium is already installed") -eq 0 ]; then
	npm install -g appium
	npm install -g appium-doctor
	npm install wd
	npm install -g ios-deploy
	gem install xcpretty 
fi

# Install Macaca Mobile Inspector
if [ $(dpkg-query -W -f='${Status}' macaca-cli 2>/dev/null | grep -c "macaca-cli is already installed") -eq 0 ]; then
	npm install -g macaca-cli
	macaca doctor
	npm install -g app-inspector
fi