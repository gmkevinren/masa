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


