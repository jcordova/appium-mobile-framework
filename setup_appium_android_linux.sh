#!/bin/sh

# Install dependencies libraries for Linuxbrew based on Linux distro
if [ "$(command -v apt-get)" ]; then
	# For Ubuntu or Debian-based Linux distributions
    sudo apt-get update
    sudo apt-get install -y build-essential curl file git python-setuptools ruby

    # Install Oracle JDK 8
    sudo apt-get purge openjdk-\*
    sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install -y oracle-java8-installer

	# Set Java environment
	sudo apt install oracle-java8-set-default

	# Test Java installation
	# export JAVA_HOME=/usr/java/jdk1.8.0
	javac -version
	echo $JAVA_HOME

elif [ "$(command -v yum)" ]; then
	# For CentOS based Linux distributions
	sudo yum update
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y curl file git irb python-setuptools ruby

    # Install Oracle JDK 8
    sudo yum remove -y java*
	wget --no-cookies \
	--no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	"http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-x64.rpm" \
	-O jdk-8-linux-x64.rpm
	sudo rpm -Uvh jdk-8-linux-x64.rpm
	sudo alternatives --install -y /usr/bin/java java /usr/java/jdk1.8.0/jre/bin/java 20000
	sudo alternatives --install -y /usr/bin/jar jar /usr/java/jdk1.8.0/bin/jar 20000
	sudo alternatives --install -y /usr/bin/javac javac /usr/java/jdk1.8.0/bin/javac 20000
	sudo alternatives --install -y /usr/bin/javaws javaws /usr/java/jdk1.8.0/jre/bin/javaws 20000
	sudo alternatives --set java -y /usr/java/jdk1.8.0/jre/bin/java
	sudo alternatives --set javaws /usr/java/jdk1.8.0/jre/bin/javaws
	sudo alternatives --set javac /usr/java/jdk1.8.0/bin/javac
	sudo alternatives --set jar /usr/java/jdk1.8.0/bin/jar

	# Test Java installation
	java -version
	# export JAVA_HOME=/usr/java/jdk1.8.0
	echo $JAVA_HOME

fi

# Install Linuxbrew
if [ $(dpkg-query -W -f='${Status}' brew 2>/dev/null | grep -c "brew is already installed") -eq 0 ]; then

	# Install Linuxbrew package manager
	echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

	# Set Linuxbrew system path
	if [ "$(command -v apt-get)" ]; then
		# For Ubuntu or Debian-based Linux distributions
	    echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.profile
	    echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.profile
	    echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
	elif [ "$(command -v yum)" ]; then
		# For CentOS based Linux distributions
		echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bash_profile
	    echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bash_profile
	    echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bash_profile
	fi

    # export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
	
	# check brew dependencies
	brew install gcc
	brew doctor
	brew help
fi

# Install NodeJS
if [ $(dpkg-query -W -f='${Status}' node 2>/dev/null | grep -c "node is already installed") -eq 0 ]; then
	brew update
	brew install node
	brew link node
fi

# Install Appium and dependencies 
if [ $(dpkg-query -W -f='${Status}' appium 2>/dev/null | grep -c "appium is already installed") -eq 0 ]; then
	npm install -g appium
	npm install -g appium-doctor
	npm install -g wd
fi

# Test Appium installation
appium -v

# Install Macaca CLI for the Inspector
if [ $(dpkg-query -W -f='${Status}' macaca 2>/dev/null | grep -c "macaca-cli is already installed") -eq 0 ]; then
	npm install -g macaca-cli
fi

# Install Android SDK
if [ "$(command -v apt-get)" ]; then
	sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
	sudo apt update 
	sudo apt install -y ubuntu-make
	umake android --accept-license
#  else if [ "$(command -v yum)" ]; then
	# echo
fi

# Install Macaca CLI for the Inspector
if [ $(dpkg-query -W -f='${Status}' macaca 2>/dev/null | grep -c "app-inspector is already installed") -eq 0 ]; then
	npm install -g app-inspector
	macaca doctor
	appium-doctor
fi