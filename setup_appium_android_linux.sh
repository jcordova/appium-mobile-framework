#!/bin/sh

# ------------------
# Install Linuxbrew
# ------------------

if ! [ -x "$(command -v brew)" ]; then

    # STEP 1. Install dependencies based on Linux distro 
    
    # For Ubuntu or Debian-based Linux distributions
    if [ "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install -y build-essential curl file git python-setuptools ruby
        
    # For CentOS based Linux distributions
    elif [ "$(command -v yum)" ]; then  
        sudo yum update
        sudo yum groupinstall -y 'Development Tools' && sudo yum install -y curl file git irb python-setuptools ruby
    fi

	# STEP 2. Install Linuxbrew package manager
	
	echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

	# STEP 3. Set Linuxbrew system path
	
    # For Ubuntu or Debian-based Linux distributions
	if [ "$(command -v apt-get)" ]; then
		echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.profile
		echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.profile
		echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
    		
    # For CentOS based Linux distributions
	elif [ "$(command -v yum)" ]; then
		echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bash_profile
		echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bash_profile
		echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bash_profile
	fi

	# Check Brew Installation
	brew install gcc
	brew doctor
	brew help
fi

# -----------------------
# Install NodeJS via brew
# -----------------------

if [ "$(command -v brew)" ]; then
	if ! [ -x "$(command -v node)" ]; then
		brew update
		brew install node
		brew link node
	fi
fi

# ---------------------------------
# Install Android SDK API/BuildTool
# ---------------------------------

if [ "$(command -v java)" ]; then

	# Veify if Oracle JDK 9 is already installed or not.
	VER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[1]}'`
	if [ $VER != 9 ]; then
		echo "You must install Oracle JDK 9 before continue ... "
		exit
	fi

	# Install Android SDK if it is NOT installed.
	if ! [ -x "$(command -v android)" ]; then

		# STEP 1 - Download android sdk

		wget http://dl.google.com/android/android-sdk_r24.2-linux.tgz
		tar -xvf android-sdk_r24.2-linux.tgz
		cd android-sdk-linux/tools

		# STEP 2 - Install all sdk packages

		./android update -y sdk --no-ui

		# STEP 3 - Set path

		vi ~/.zshrc <<- EOT
		export PATH=${PATH}:$HOME/sdk/android-sdk-linux/platform-tools:$HOME/sdk/android-sdk-linux/tools:$HOME/sdk/android-sdk-linux/build-tools/22.0.1/
		EOT
		source ~/.zshrc

		# STEP 4 - Install dependencies based on Linux distro

		# For Ubuntu or Debian-based Linux distributions
		if [ "$(command -v apt-get)" ]; then
			apt-get -f install
			# adb
			sudo apt-get install -y libc6:i386 libstdc++6:i386
			# aapt
			sudo apt-get install -y zlib1g:i386

		# For CentOS based Linux distributions
		elif [ "$(command -v yum)" ]; then
			yum -f install
			# adb
			sudo yum install -y libc6:i386 libstdc++6:i386
			# aapt
			sudo yum install -y zlib1g:i386
		fi

		# STEP 5 - Set Android-SDK Permission
		sudo chmod 705 /opt/android-sdk/tools/android
 	fi

else
	echo "You must install Oracle JDK 9 before continue ... "
	exit
fi

# ---------------------------------------------
# Install Appium and dependencies via node/npm
# ---------------------------------------------

if [ "$(command -v npm)" ]; then
	if ! [ -x "$(command -v appium)" ]; then	
		npm install -g appium
		npm install -g appium-doctor
		npm install -g wd
	fi

	# Test Appium installation
	appium -v

	# Install Macaca CLI and Macaca Inspector
	if ! [ -x "$(command -v macaca)" ]; then
		npm install -g macaca-cli
		npm install -g app-inspector
	fi

	# Test Macaca installation
	macaca doctor
	appium-doctor
fi