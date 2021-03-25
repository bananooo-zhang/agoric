# agoric
入职
安装+成为验证人
服务器环境Ubuntu20.04


curl https://deb.nodesource.com/setup_12.x | sudo bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt upgrade -y
sudo apt install nodejs=12.* yarn build-essential jq -y
sudo rm -rf /usr/local/go
curl https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -

cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

source $HOME/.profile
git clone https://github.com/Agoric/agoric-sdk -b @agoric/sdk@2.15.1
cd agoric-sdk
yarn install
yarn build
cd packages/cosmic-swingset && make
curl https://testnet.agoric.net/network-config > chain.json
chainName=`jq -r .chainName < chain.json`
echo $chainName
ag-chain-cosmos init --chain-id $chainName <your_moniker>
curl https://testnet.agoric.net/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json 
ag-chain-cosmos unsafe-reset-all
peers=$(jq '.peers | join(",")' < chain.json)
seeds=$(jq '.seeds | join(",")' < chain.json)
echo $peers
echo $seeds
sed -i.bak 's/^log_level/# log_level/' $HOME/.ag-chain-cosmos/config/config.toml
sed -i.bak -e "s/^seeds *=.*/seeds = $seeds/; s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml

sudo tee <<EOF >/dev/null /etc/systemd/system/ag-chain-cosmos.service
[Unit]
Description=Agoric Cosmos daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/ag-chain-cosmos start --log_level=warn
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable ag-chain-cosmos
sudo systemctl daemon-reload
sudo systemctl start ag-chain-cosmos
ag-cosmos-helper status 2>&1 | jq .SyncInfo
ag-cosmos-helper keys add <your-key-name>
领测试币
ag-chain-cosmos tendermint show-validator
chainName=`curl https://testnet.agoric.net/network-config | jq -r .chainName`
echo $chainName

ag-cosmos-helper tx staking create-validator \
  --amount=50000000uagstake \
  --broadcast-mode=block \
  --pubkey=<your-agoricvalconspub1-key> \
  --moniker=<your-node-name> \
  --website=<your-node-website> \
  --details=<your-node-details> \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --from=<your-key-name> \
  --chain-id=$chainName \
  --gas=auto \
  --gas-adjustment=1.4
  
  在浏览器上检查自己的名字
