#!/usr/bin/bash

set -e

function sudoCheck {
  user=$(whoami)
  if [ "$user" != "root" ]; then
    echo "Use Sudo su"
    exit 1
  fi
}

function osCheck() {
  case $(uname -s) in
  Linux) echo "In Progress ... " ;;
  *)
    echo "You are not using Linux!"
    exit 1
    ;;
  esac
}

function dockerInstaller() {
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo usermod -a -G docker $USER
}

function dockerComposeInstaller() {
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

echo "Please Enter Your Choice: "

while true; do
  select option in "Install Docker" "Install Docker Compose" Exit; do
    case $option in
    ##Install Docker
    "Install Docker")
      osCheck
      sudoCheck
      dockerInstaller
      echo "All Done!, Anything else? "
      break
      ;;
      ##Install Docker-Compose
    "Install Docker Compose")
      osCheck
      sudoCheck
      dockerComposeInstaller
      ;;
      ##Exit
    "Exit")
      echo "Have a nice day :)"
      exit 1
      ;;
    esac
  done
done
