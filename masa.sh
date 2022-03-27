#!/bin/bash
read -p "Enter your node name: " MASA_NODENAME

#第一步，更新和安装依赖

sudo apt update && sudo apt upgrade -y


# 安装依赖
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y


# 安装GO 1.17.2
wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
export PATH=$PATH:/usr/local/go/bin
source ~/.profile
#测试是否安装成功:
go version

#开放30300端口
ufw allow 30300

第二步，安装masa
cd 
rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0

cd masa-node-v1.0/src
git checkout v1.03
make all

#复制二进制文件
cd $HOME/masa-node-v1.0/src/build/bin
sudo cp * /usr/local/bin

#初始化
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json


# 创建服务

tee $HOME/masad.service > /dev/null <<EOF
[Unit]
Description=MASA103
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which geth) \
  --identity ${MASA_NODENAME} \
  --datadir $HOME/masa-node-v1.0/data \
  --port 30300 \
  --syncmode full \
  --verbosity 5 \
  --emitcheckpoints \
  --istanbul.blockperiod 10 \
  --mine \
  --miner.threads 1 \
  --networkid 190260 \
  --http --http.corsdomain "*" --http.vhosts "*" --http.addr 127.0.0.1 --http.port 8545 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --maxpeers 50 \
  --bootnodes enode://91a3c3d5e76b0acf05d9abddee959f1bcbc7c91537d2629288a9edd7a3df90acaa46ffba0e0e5d49a20598e0960ac458d76eb8fa92a1d64938c0a3a3d60f8be4@54.158.188.182:21000
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/masad.service /etc/systemd/system

#启动服务
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad 
#查看日志

sleep 10s

geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://985ec4c508f3d0d8ea383179a27a9152475aef6a8110d8bd40ae516b14fd81ae897cbdb6ec4c8c27c3cc2ae60ee64af069587ea41aa799eccb70548e0fd63b14@74.201.30.5:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://5944f52059b1703adb054bfc9acc3923b8506d55dca6995499c9e4ec3a3e9249c7a64f222ffa4bc7a88ccd6046eb0895a080a5e1dbfcf47a9254ba9748c56e28@65.108.220.81:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://7612454dd41a6d13138b565a9e14a35bef4804204d92e751cfe2625648666b703525d821f34ffc198fac0d669a12d5f47e7cf15de4ebe65f39822a2523a576c4@81.29.137.40:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://233148d7db693112b6f9937b5eeb2bd9ad8c3cf40b42d8c6312a7898e9aa22f79bae49dcf544a2e86377f5e11f22abfff47374aeb9285fed2202d0f4fa40fb1c@188.166.175.209:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://c19ccf1fd8027684f80e12e08e77584e6678953b88571338baf68d5cec8ca78c9a5de243df981407ebdbcef52f0ba8431571908870f76e0dcc137d932cebdcbd@95.214.55.51:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://adf9fbf112e264e5cb3f337c7a77e0d7789c8e666173791eafd42e196dc98033a3d9b28864c39544def8b279ef05719613ba08ec17f2cae615043b95a551b394@45.155.207.246:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://a809201ff1cbea796475b6827f3fe549c614ccecdc0e25106aa90652e417b63db6c324e32e9cb2b3fb0c3ae2bd59483b044c01563d96deb402df1cca44c1f982@162.55.43.133:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://d0fff27a48dd50b7128060f7d8a55699c855ffdec1ef5a6c06d433dce4bfb3b6567166cadac1a11bb744bbcbf3e5314b788b611289e379d271140d3438153ef5@135.181.212.183:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://575a35b2ffb3e1af698fd61350914caa69b20a641840ddfa4d737e77c12024d9bb4474ec404ed3aa9587c28b3bbe9d5568a050a0b064a826e19587d6d05c78bf@65.21.131.215:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://1f0ad6628d8d5ed964509e86fce79dfb115bd15c7602adc52e5a2d18a42a9b0eb91153bf153186ea275160eee842cdd62ef6466168d8b595299e639e86dfbe4b@78.46.150.209:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://ed63eff3ab49caf2a100729bd40844c76e787804bbc82b6e65d6b52412e7ba8fe45f18d263167714b350bb32fa170fa4b86290a5cfbcfacdda3cb9206e926d94@65.21.180.25:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://7612454dd41a6d13138b565a9e14a35bef4804204d92e751cfe2625648666b703525d821f34ffc198fac0d669a12d5f47e7cf15de4ebe65f39822a2523a576c4@81.29.137.40:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://da730611bb956ce75b63cd356a10cf7d08576e03b038e46ee67085fa0b7c602e851bfbb89d77b760220c84127c50eb34a1ba56da402ffe7360da2118d679faa0@65.21.159.253:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://a92d1d44e2ac6930367cf99ff3255235385a42cdf615e37c1f259c54240ff86d5516c45d1d551cb2647da7052b9e28cb2cd68128bdba613635aa328a29644bf7@185.205.244.179:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://484dcfffc18dd7f4c984fd07328d0b61c9a617a563b915bd011109202aeb0bf30b27bfb54a4175f0d10f8114c73ed3369150af849de5b38be1c7eada89a9730b@185.187.170.57:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://70dd34518cffb3a57be0a5e96b095d864910df450836b3a92844d929e254a4981b0f879487cbc0888b5c8fd3b8248e7b4876c3eeb0432492d55bdb98128c19ae@195.2.76.77:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://3d0c2c71ad144b5c1490a110fc9be533332cc18c8df953763eb2e79686f938ab5ea03f6cda058a4b271ed9115e9df8a09e261537afc9cbe84eb7c76b49352870@95.217.204.111:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://4652f6da837a804f1810bc89ae58889855a38d73554c528fc19c5e17bbc2eaa1647aa22545b4820cee26363b8204190f322a1dd157d2f2186d49258eb224c6db@51.195.234.246:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://312fec2b650e5e1c631f4e9ad2083c3ec4a0e2c6cc2a4c838d1abc42a5b560d50e8c5cb583d6d8db8276427ee6fce40353ca4b7ecd6d3726d3083c95f6c0f651@139.59.231.153:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://6a23e976859be6a8b9093b48d4414b953004b66ddbddf1e61df041446cd116127ddc8ac415e338b04abdfe6946f10e4142f9aa9b2f6a7b49d10c9d101e4f2edf@82.146.35.68:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://233148d7db693112b6f9937b5eeb2bd9ad8c3cf40b42d8c6312a7898e9aa22f79bae49dcf544a2e86377f5e11f22abfff47374aeb9285fed2202d0f4fa40fb1c@188.166.175.209:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://c19ccf1fd8027684f80e12e08e77584e6678953b88571338baf68d5cec8ca78c9a5de243df981407ebdbcef52f0ba8431571908870f76e0dcc137d932cebdcbd@95.214.55.51:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://adf9fbf112e264e5cb3f337c7a77e0d7789c8e666173791eafd42e196dc98033a3d9b28864c39544def8b279ef05719613ba08ec17f2cae615043b95a551b394@45.155.207.246:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://a809201ff1cbea796475b6827f3fe549c614ccecdc0e25106aa90652e417b63db6c324e32e9cb2b3fb0c3ae2bd59483b044c01563d96deb402df1cca44c1f982@162.55.43.133:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://d0fff27a48dd50b7128060f7d8a55699c855ffdec1ef5a6c06d433dce4bfb3b6567166cadac1a11bb744bbcbf3e5314b788b611289e379d271140d3438153ef5@135.181.212.183:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://575a35b2ffb3e1af698fd61350914caa69b20a641840ddfa4d737e77c12024d9bb4474ec404ed3aa9587c28b3bbe9d5568a050a0b064a826e19587d6d05c78bf@65.21.131.215:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://1f0ad6628d8d5ed964509e86fce79dfb115bd15c7602adc52e5a2d18a42a9b0eb91153bf153186ea275160eee842cdd62ef6466168d8b595299e639e86dfbe4b@78.46.150.209:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://ed63eff3ab49caf2a100729bd40844c76e787804bbc82b6e65d6b52412e7ba8fe45f18d263167714b350bb32fa170fa4b86290a5cfbcfacdda3cb9206e926d94@65.21.180.25:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://a776f201991b5ae0428bbc3676572a5dba8120fde282c0de917d8e4776330e4eca2033fb55696cac700e5d88e24c8e9e739cf004cbd1fc33638742fdeb4256eb@130.255.170.151:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://69b0339d0e7c295d1cf1de54540b921b8c63a25314ea7e5f58daf1ea850e4539890cc6e22c0427b3204cbdcbadcb69087beb279100ebb4511649f0fbfb6c3780@46.101.73.148:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://4508f51c285be2b76b712a7c5d213fcbe8dbfb3495ceec6b3ec8c75296e9548b4c8880c51ecf615294c40f24b03026fd5b0e809f0141a09369bffb3fec953d52@139.59.140.15:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://96feab0936f4128eb7f3e80b95f2201f183af8cf663dd0db3bcb022c867bad5fb58194966411a813d60961a5ee4823ceaea39e9de5bbc15984a4b5fc7800de77@157.90.225.116:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://571be7fe060b183037db29f8fe08e4fed6e87fbb6e7bc24bc34e562adf09e29e06067be14e8b8f0f2581966f3424325e5093daae2f6afde0b5d334c2cd104c79@142.132.135.228:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://269ecefca0b4cd09bf959c2029b2c2caf76b34289eb6717d735ce4ca49fbafa91de8182dd701171739a8eaa5d043dcae16aee212fe5fadf9ed8fa6a24a56951c@65.108.72.177:21000") 
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://fcb5a1a8d65eb167cd3030ca9ae35aa8e290b9add3eb46481d0fbd1eb10065aeea40059f48314c88816aab2af9303e193becc511b1035c9fd8dbe97d21f913b9@52.1.125.71:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://d87c03855093a39dced2af54d39b827e4e841fd0ca98673b2e94681d9d52d2f1b6a6d42754da86fa8f53d8105896fda44f3012be0ceb6342e114b0f01456924c@34.225.220.240:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://91a3c3d5e76b0acf05d9abddee959f1bcbc7c91537d2629288a9edd7a3df90acaa46ffba0e0e5d49a20598e0960ac458d76eb8fa92a1d64938c0a3a3d60f8be4@54.158.188.182:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://ac6b1096ca56b9f6d004b779ae3728bf83f8e22453404cc3cef16a3d9b96608bc67c4b30db88e0a5a6c6390213f7acbe1153ff6d23ce57380104288ae19373ef@54.146.254.245:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://66a2cf69e25f68438988cdde23d962722db7f2ce3e792ff25f5f0a94ba0423f5618f91b7c749141b3ebe40dd1d28476e9f42612fe74091249993130dcf245376@138.201.155.226:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://b559beaaac0c121122dec1f287be0722746ab4bcb68ac1ad2de70b1d50a801e4d1fb3102f41f27a9a396fa8a0aca8d116099141369301eb8e1ddd8b37cf2c2b4@138.201.91.105:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://843ec5c9d67d5a849722eb2a4ffd062f3b298b670412b8ae29cb0ddb137f706de773ab8ec62197a7bd58a93612c0b0bd15261b7235b2183c1837752057b1051b@95.217.211.32:21000")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://1fb35ec2ebc538c3e09bfa58cbb6857c9c7c35309fb44dc24850b53c8f34387b70ef053bb9bc8ba26c79dd8f1d5f85189cd8c20c9c28f0923363dd8823a857a0@92.63.101.152:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://f719d999da85e86f2bfee836d00cee216d55aa9e3b98b691cbf91b190b536b68732ba9fc7df1607bfabec53a784682af5b862f42289cf370cf69f3c9a1ce06bf@185.185.83.23:30300")
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.addPeer("enode://93044a106ce0f77987414296b4954dff93cb2cd9ee4c4b6905f5d4f7d53e36346a023b854a1d8e3b82bcf8d28f6e7f5d6b716221e100742ca78fd76139990f62@127.0.0.1:30300")

sleep 10s

geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo |grep enode | sed {s/127\.0\.0\.1/`curl -s 2ip.ru`/} | sed "s/^.*\"\(.*\)\".*$/\1/"