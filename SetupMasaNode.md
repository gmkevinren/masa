# 安装MASA激励测试教程
## 第一步，更新和安装依赖
```
sudo apt update && sudo apt upgrade -y
```
**安装依赖**
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```
**安装GO 1.17.2**
```
wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
export PATH=$PATH:/usr/local/go/bin
source ~/.profile
```
**测试是否安装成功:**
```
go version
```

## 第二步，安装masa
```
cd 
rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0
```
```
cd masa-node-v1.0/src
git checkout v1.03
make all
```
**复制二进制文件**
```
cd $HOME/masa-node-v1.0/src/build/bin
sudo cp * /usr/local/bin
```
**初始化**
```
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
```
**替换“你的节点名字”**
```
MASA_NODENAME="你的节点名字"
```
**创建服务（把下面一整段代码一块复制粘贴）**
```
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
```
**启动服务**
```
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad 
```
**查看日志**
```
journalctl -u masad -f -o cat
```
**CTRL+C 关闭**

## 第三步，其他有用的命令，查看同步及申请激励**
**Geth 终端运行**
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```
**查看是否同步：false就对了**
```eth.syncing```

**查看节点信息**
```admin.nodeInfo```

**查看高度**
```eth.blockNumber```

**查看是否监听**
```net.listening```

**查看连接的种子数**
```net.peerCount```

**如果是0的，手动添加peers**

```
admin.addPeer("enode://5944f52059b1703adb054bfc9acc3923b8506d55dca6995499c9e4ec3a3e9249c7a64f222ffa4bc7a88ccd6046eb0895a080a5e1dbfcf47a9254ba9748c56e28@65.108.220.81:30300")
admin.addPeer("enode://7612454dd41a6d13138b565a9e14a35bef4804204d92e751cfe2625648666b703525d821f34ffc198fac0d669a12d5f47e7cf15de4ebe65f39822a2523a576c4@81.29.137.40:30300")
admin.addPeer("enode://233148d7db693112b6f9937b5eeb2bd9ad8c3cf40b42d8c6312a7898e9aa22f79bae49dcf544a2e86377f5e11f22abfff47374aeb9285fed2202d0f4fa40fb1c@188.166.175.209:30300")
admin.addPeer("enode://c19ccf1fd8027684f80e12e08e77584e6678953b88571338baf68d5cec8ca78c9a5de243df981407ebdbcef52f0ba8431571908870f76e0dcc137d932cebdcbd@95.214.55.51:30300")
admin.addPeer("enode://adf9fbf112e264e5cb3f337c7a77e0d7789c8e666173791eafd42e196dc98033a3d9b28864c39544def8b279ef05719613ba08ec17f2cae615043b95a551b394@45.155.207.246:30300")
admin.addPeer("enode://a809201ff1cbea796475b6827f3fe549c614ccecdc0e25106aa90652e417b63db6c324e32e9cb2b3fb0c3ae2bd59483b044c01563d96deb402df1cca44c1f982@162.55.43.133:30300")
admin.addPeer("enode://d0fff27a48dd50b7128060f7d8a55699c855ffdec1ef5a6c06d433dce4bfb3b6567166cadac1a11bb744bbcbf3e5314b788b611289e379d271140d3438153ef5@135.181.212.183:30300")
admin.addPeer("enode://575a35b2ffb3e1af698fd61350914caa69b20a641840ddfa4d737e77c12024d9bb4474ec404ed3aa9587c28b3bbe9d5568a050a0b064a826e19587d6d05c78bf@65.21.131.215:30300")
admin.addPeer("enode://1f0ad6628d8d5ed964509e86fce79dfb115bd15c7602adc52e5a2d18a42a9b0eb91153bf153186ea275160eee842cdd62ef6466168d8b595299e639e86dfbe4b@78.46.150.209:30300")
admin.addPeer("enode://ed63eff3ab49caf2a100729bd40844c76e787804bbc82b6e65d6b52412e7ba8fe45f18d263167714b350bb32fa170fa4b86290a5cfbcfacdda3cb9206e926d94@65.21.180.25:30300")
admin.addPeer("enode://7612454dd41a6d13138b565a9e14a35bef4804204d92e751cfe2625648666b703525d821f34ffc198fac0d669a12d5f47e7cf15de4ebe65f39822a2523a576c4@81.29.137.40:30300")
admin.addPeer("enode://da730611bb956ce75b63cd356a10cf7d08576e03b038e46ee67085fa0b7c602e851bfbb89d77b760220c84127c50eb34a1ba56da402ffe7360da2118d679faa0@65.21.159.253:30300")
admin.addPeer("enode://a92d1d44e2ac6930367cf99ff3255235385a42cdf615e37c1f259c54240ff86d5516c45d1d551cb2647da7052b9e28cb2cd68128bdba613635aa328a29644bf7@185.205.244.179:30300")
admin.addPeer("enode://484dcfffc18dd7f4c984fd07328d0b61c9a617a563b915bd011109202aeb0bf30b27bfb54a4175f0d10f8114c73ed3369150af849de5b38be1c7eada89a9730b@185.187.170.57:30300")
admin.addPeer("enode://70dd34518cffb3a57be0a5e96b095d864910df450836b3a92844d929e254a4981b0f879487cbc0888b5c8fd3b8248e7b4876c3eeb0432492d55bdb98128c19ae@195.2.76.77:30300")
admin.addPeer("enode://3d0c2c71ad144b5c1490a110fc9be533332cc18c8df953763eb2e79686f938ab5ea03f6cda058a4b271ed9115e9df8a09e261537afc9cbe84eb7c76b49352870@95.217.204.111:30300")
admin.addPeer("enode://4652f6da837a804f1810bc89ae58889855a38d73554c528fc19c5e17bbc2eaa1647aa22545b4820cee26363b8204190f322a1dd157d2f2186d49258eb224c6db@51.195.234.246:30300")
admin.addPeer("enode://312fec2b650e5e1c631f4e9ad2083c3ec4a0e2c6cc2a4c838d1abc42a5b560d50e8c5cb583d6d8db8276427ee6fce40353ca4b7ecd6d3726d3083c95f6c0f651@139.59.231.153:30300")
admin.addPeer("enode://6a23e976859be6a8b9093b48d4414b953004b66ddbddf1e61df041446cd116127ddc8ac415e338b04abdfe6946f10e4142f9aa9b2f6a7b49d10c9d101e4f2edf@82.146.35.68:30300")
```



**CTRL+D 关闭Geth终端**

**查看节点信息**
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo |grep enode | sed {s/127\.0\.0\.1/`curl -s 2ip.ru`/} | sed "s/^.*\"\(.*\)\".*$/\1/"
```

**把enode id后的一串字符复制下来**


**【填表申请激励】**：https://forms.gle/Z3P3Yaeodw88HPAA8

**备份私钥：**： $HOME/masa-node-v1.0/data/geth/nodekey


**提醒：记得保留运行日志！！！**

**提醒：记得保留运行日志！！！**

**提醒：记得保留运行日志！！！**

**重要事情说三遍**

### 其他链接：
Github:https://github.com/masa-finance/masa-node-v1.0

文档：https://developers.masa.finance/docs

Discord: https://discord.gg/NJKEFTmcaB


