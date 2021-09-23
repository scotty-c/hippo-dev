#!/usr/bin/env bash
set -ex pipefail

export DEBIAN_FRONTEND=noninteractive

echo "# make..."
sudo apt update 
sudo apt install -y \
         git \
         nodejs \
         npm \

        
echo "# rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup target add wasm32-wasi

echo "# dotnet5..."
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0

echo "# wagi..."
VERSION=v0.4.0
wget https://github.com/deislabs/wagi/releases/download/$VERSION/wagi-$VERSION-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf wagi-$VERSION-linux-amd64.tar.gz

echo "bindle..."
wget https://bindle.blob.core.windows.net/releases/bindle-v0.6.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf bindle-v0.6.0-linux-amd64.tar.gz
sudo chown -R ubuntu:ubuntu /home/ubuntu/.config/bindle
bindle-server --unauthenticated &

echo "# hipo..."
git clone https://github.com/deislabs/hippo.git
cd hippo/Hippo
dotnet restore
npm run build
export BINDLE_URL=http://localhost:8080/v1
dotnet run
wget https://github.com/deislabs/hippo-cli/releases/download/v0.9.0/hippo-v0.9.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf hippo-v0.9.0-linux-amd64.tar.gz

echo "# yo-wasm..."
npm install -g yo
npm install -g generator-wasm

echo "# complete!"