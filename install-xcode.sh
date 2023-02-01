#!/bin/zsh
# If Xcode is not installed, this script will install the latest available version of Xcode.
swupdate="/usr/sbin/softwareupdate"

echo ""
echo "If Xcode is not installed, this script will install the latest available version of Xcode."
echo "Checking if Command Line Tools for Xcode is already installed."
echo ""

xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
	echo "Command Line Tools for Xcode not found.  Installing from softwareupdate..."
  echo ""

# This temporary file is added to nudge the softwareupdate utility to list available Command Line Tools for Xcode to install.
	touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  
	XCODE=$($swupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
	$swupdate -i "$XCODE" --verbose;
else
	echo "Command Line Tools for Xcode is already installed. Not installing Xcode."
fi
