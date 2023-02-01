#!/bin/zsh
# If Xcode is not installed, this script will install the latest available version of Xcode.

swupdate="/usr/sbin/softwareupdate"

getc() {
  local save_state
  save_state="$(/bin/stty -g)"
  /bin/stty raw -echo
  IFS='' read -r -n 1 -d '' "$@"
  /bin/stty "${save_state}"
}

ring_bell() {
  # Use the shell's audible bell.
  if [[ -t 1 ]]
  then
    printf "\a"
  fi
}

wait_for_user() {
  local c
  echo
  echo "Press ${tty_bold}RETURN${tty_reset}/${tty_bold}ENTER${tty_reset} to continue or any other key to abort:"
  getc c
  # we test for \r and \n because some stuff does \r instead
  if ! [[ "${c}" == $'\r' || "${c}" == $'\n' ]]
  then
    exit 1
  fi
}

echo ""
echo "If Xcode is not installed, this script will install the latest available version of Xcode."
wait_for_user
echo "Checking if Command Line Tools for Xcode is already installed."
echo ""

xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Command Line Tools for Xcode not found.  Ready from softwareupdate..."
  ring_bell
  wait_for_user()
  echo ""

# This temporary file is added to nudge the softwareupdate utility to list available Command Line Tools for Xcode to install.
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  
  XCODE=$($swupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  $swupdate -i "$XCODE" --verbose;
else
  echo "Command Line Tools for Xcode is already installed. Not installing Xcode."
fi
