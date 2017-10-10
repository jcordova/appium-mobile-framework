#!/bin/sh

# Install Homebrew
which brew &> /dev/null;
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo updating brew
    brew update
fi;

# Install Appium dependencies
which libimobiledevice &> /dev/null;
if [[ $? != 0 ]] ; then
    brew install libimobiledevice --HEAD
fi;

which carthage &> /dev/null;
if [[ $? != 0 ]] ; then
    brew install carthage
fi;

which node &> /dev/null;
if [[ $? != 0 ]] ; then
    brew install node
fi;

# Install Appium modules 
which appium &> /dev/null;
if [[ $? != 0 ]] ; then
	npm install -g appium
	npm install -g appium-doctor
	npm install wd
	npm install -g ios-deploy
	gem install xcpretty 
fi;

# Install Macaca Mobile Inspector
which macaca &> /dev/null;
if [[ $? != 0 ]] ; then
	npm install macaca-cli -g
	macaca doctor
	npm install app-inspector -g
fi;