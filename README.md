# agoric

summary

Explore setting up Promethean monitoring without losing blocks due to setting up monitoring

The principle of

The deployment of Prometheus monitoring is completed before the pledge. After the monitoring can be opened through the web page, the pledge is finally made

The effect

No block was lost due to the setting of Prometheus

methods

1. Start the verifier

2.vi ~/.ag-chain-cosmos/config/app.toml(

([telemetry]

enabled = true

prometheus-retention-time = 60



[api]

# Note: this key is "enable" (without a "d", not "enabled")

enable = true

Address = "TCP: / / 0.0.0.0:1317)"

3.vi ~/.ag-chain-cosmos/config/config.toml

([instrumentation]

prometheus = true

prometheus_listen_addr = ":26660")

4.

export OTEL_EXPORTER_PROMETHEUS_HOST=

5.OTEL_EXPORTER_PROMETHEUS_PORT=9464 ag-chain-cosmos start --log_level=warn

6. Check with "at http://id:26660" to open it

7. The pledge





Here's a simple tutorial for running Node alone, step by step

Server environment Ubuntu20.04





curl https://deb.nodesource.com/setup_12.x | sudo bash

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update

sudo apt upgrade -y

sudo apt install nodejs=12.* yarn build-essential jq -y

sudo rm -rf /usr/local/go

The curl https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz | sudo tar - C/usr/local - ZXVF -



cat <<'EOF' >>$HOME/.profile

export GOROOT=/usr/local/go

export GOPATH=$HOME/go

export GO111MODULE=on

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

EOF



source $HOME/.profile

Git clone https://github.com/Agoric/agoric-sdk - b @ agoric/sdk@2.15.1

cd agoric-sdk

yarn install

yarn build

cd packages/cosmic-swingset && make

curl https://testnet.agoric.net/network-config > chain.json

chainName=`jq -r .chainName < chain.json`

echo $chainName

ag-chain-cosmos init --chain-id $chainName

curl https://testnet.agoric.net/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json

ag-chain-cosmos unsafe-reset-all

peers=$(jq '.peers | join(",")' < chain.json)

seeds=$(jq '.seeds | join(",")' < chain.json)

echo $peers

echo $seeds

sed -i.bak 's/^log_level/# log_level/' $HOME/.ag-chain-cosmos/config/config.toml

sed -i.bak -e "s/^seeds *=.*/seeds = $seeds/; s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml



sudo tee </dev/null /etc/systemd/system/ag-chain-cosmos.service

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

ag-cosmos-helper keys add

Led test currency

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



Check your name in the browser
