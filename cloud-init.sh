#!/usr/bin/env bash
set -ex pipefail

export DEBIAN_FRONTEND=noninteractive

echo "# make..."
sudo apt update 
sudo apt install -y \
         git \
         build-essential \
         pkg-config

echo "# nodejs"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
nvm install 'v16.13.0'
nvm use 'v16.13.0'
        
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
  sudo apt-get install -y aspnetcore-runtime-5.0 \
                          dotnet-sdk-5.0 

echo "# wagi..."
VERSION=v0.4.0
wget https://github.com/deislabs/wagi/releases/download/$VERSION/wagi-$VERSION-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf wagi-$VERSION-linux-amd64.tar.gz

echo "# bindle..."
wget https://bindle.blob.core.windows.net/releases/bindle-v0.6.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf bindle-v0.6.0-linux-amd64.tar.gz
sudo mkdir -p /home/ubuntu/.config/bindle
sudo chown -R ubuntu:ubuntu /home/ubuntu/.config/bindle

echo "# bindle daemon file..."
sudo tee -a /etc/systemd/system/bindle.service <<'EOF'
[Unit]
Description=Bindle server
[Service]
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/bindle-server --unauthenticated --address 0.0.0.0:8080
User=ubuntu
Group=ubuntu
[Install]
WantedBy=multi-user.target
EOF
sudo chmod +x /etc/systemd/system/bindle.service

echo "# starting bindle ..."
sudo systemctl enable bindle
sudo systemctl start bindle

echo "# waiting for bindle to start ..."            
sleep 5 # wait for bindle to start

echo "# yo-wasm..."
npm install -g yo
npm install -g generator-wasm

echo "# wasmtime"
curl https://wasmtime.dev/install.sh -sSf | bash
export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

echo '# hippo CLI'
wget https://github.com/deislabs/hippo-cli/releases/download/v0.9.0/hippo-v0.9.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf hippo-v0.9.0-linux-amd64.tar.gz

echo "# hippo..."
git clone https://github.com/deislabs/hippo.git
cd hippo
git checkout tags/v0.1.0 -b localdev
cd Hippo
dotnet restore
npm run build
dotnet build
cp -r wwwroot /home/ubuntu/hippo/Hippo/bin/Debug/net5.0/


echo "# hippo daemon file..."
sudo tee -a /etc/systemd/system/hippo.service <<'EOF'
[Unit]
Description=Hippo server
[Service]
Restart=on-failure
RestartSec=5s
Environment=BINDLE_URL=http://localhost:8080/v1
Environment=ASPNETCORE_ENVIRONMENT=Development
Environment=HOME=/home/ubuntu
WorkingDirectory=/home/ubuntu/hippo/Hippo/bin/Debug/net5.0/
ExecStart=/home/ubuntu/hippo/Hippo/bin/Debug/net5.0/hippo-server
User=root
Group=root
[Install]
WantedBy=multi-user.target
EOF

sudo chmod +x /etc/systemd/system/hippo.service

echo "# starting hippo ..."
sudo systemctl enable hippo
sudo systemctl start hippo

echo "# waiting for hippo to start ..."            
sleep 5 # wait for hippo to start

sudo chown -R ubuntu:ubuntu /home/ubuntu

echo "# complete!"
echo "You can access hippo at https://localhost:5001"
echo "You can start a new WASM project with:"
echo "  export USER=admin"
echo "  export HIPPO_USERNAME=admin"
echo "  export HIPPO_PASSWORD='Passw0rd!'"
echo "  export HIPPO_URL=https://localhost:5001"
echo "  export BINDLE_URL=http://localhost:8080/v1"
echo "  export GLOBAL_AGENT_FORCE_GLOBAL_AGENT=false"
echo "  yo wasm"
echo "and follow the prompts"