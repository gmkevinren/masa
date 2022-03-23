# 安装MASA激励测试教程
## 第一步，更新和安装依赖
```
sudo apt update && sudo apt upgrade -y
```
### 安装依赖
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```
### 安装GO 1.17.2
```
wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
export PATH=$PATH:/usr/local/go/bin
source ~/.profile
```
### 测试是否安装成功:
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
### 复制二进制文件
```
cd $HOME/masa-node-v1.0/src/build/bin
sudo cp * /usr/local/bin
```
#### 初始化
```
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
```
### 替换“你的节点名字”
```
MASA_NODENAME="你的节点名字"
```
### 创建服务（把下面一整段代码一块复制粘贴）
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
### 启动服务
```
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad 
```
### 查看日志
```
journalctl -u masad -f -o cat
```
### CTRL+C 关闭

## 第三步，其他有用的命令，查看同步及申请激励
### Geth 终端运行
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```
### 在Geth终端内查看同步状态和种子数：
```eth.syncing```

```net.peerCount```

### 查看节点信息
```admin.nodeInfo```
### 把id后的一串字符复制下来
### CTRL+D 关闭Geth终端
### [填表申请激励](https://forms.gle/Z3P3Yaeodw88HPAA8)：https://forms.gle/Z3P3Yaeodw88HPAA8

### 其他链接：
https://github.com/masa-finance/masa-node-v1.0

https://developers.masa.finance/docs


