#Creatr a new file,and copy this command,use ./ start
curl https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
echo "y" | apt install git
echo "y" | apt install expect
git clone https://github.com/Agoric/agoric-sdk -b @agoric/sdk@2.15.1
cd agoric-sdk
yarn install
yarn build
cd packages/cosmic-swingset && make
cd /root/agoric-sdk
curl https://testnet.agoric.com/network-config > chain.json
chainName=`jq -r .chainName < chain.json`
echo $chainName
ag-chain-cosmos init --chain-id $chainName $1
curl https://testnet.agoric.com/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json
ag-chain-cosmos unsafe-reset-all
peers=`jq '.peers | join(",")' < chain.json`
seeds=`jq '.seeds | join(",")' < chain.jso
echo $peers
sed -i.bak 's/^log_level/# log_level/' $HOME/.ag-chain-cosmos/config/config.toml
sed -i.bak -e "s/^seeds *=.*/seeds = $seeds/; s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml
tee <<EOF >/dev/null /etc/systemd/system/ag-chain-cosmos.service
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


systemctl enable ag-chain-cosmos
systemctl daemon-reload
systemctl start ag-chain-cosmos
sleep 10
#systemctl status ag-chain-cosmos

expect -c "
spawn ag-cosmos-helper keys add $name
