source setenv.sh
echo -e "\033\033[32m 1.-------> 启动网络 \033[0m"
docker network create mynet


echo -e "\033\033[32m 2.-------> 启动influxdb \033[0m"
sudo docker run -itd  --net=mynet --name influxdb -v $LOCALDATAPATH/influxdb:/var/lib/influxdb -v $HOMEPATH/configs/influxdb.conf:/etc/influxdb.conf -p 8083:8083 -p 8086:8086 influxdb



echo -e "\033\033[32m 3.-------> 启动grafana \033[0m"
sudo docker run -itd  --net=mynet --name grafana -v $LOCALDATAPATH/grafana:/var/lib/grafana  -p 3000:3000  grafana/grafana


echo -e "\033\033[32m 4.-------> 启动etcd \033[0m"

sudo docker run -itd  --net=mynet --name etcd -v $LOCALDATAPATH/etcd:/var/lib/etcd  -v $BINROOT/etcd:/root/etcd -p 2379:2379 -p 4001:4001 centos:centos6 bash -c "cd ~ && ./etcd --data-dir='/var/lib/etcd' --advertise-client-urls='http://0.0.0.0:2379,http://0.0.0.0:4001' --listen-client-urls='http://0.0.0.0:2379,http://0.0.0.0:4001'"



echo -e "\033\033[32m 5.-------> 启动relay \033[0m"
sudo docker run -itd --net=mynet --name relay -v $BINROOT/relay:/root/relay -v $HOMEPATH/configs/relay.toml:/etc/relay.toml  centos:centos6 bash -c "cd ~ && ./relay -config='/etc/relay.toml'"


echo -e "\033\033[32m 6.-------> 启动gateway \033[0m"

sudo docker run -itd --net=mynet --name gateway -v $BINROOT/gateway:/root/gateway -v $HOMEPATH/configs/gateway.toml:/etc/gateway.toml  centos:centos6 bash -c "cd ~ && ./gateway -config='/etc/gateway.toml'"


echo -e "\033\033[32m 7.-------> 启动agent \033[0m"

sudo docker run -itd --net=mynet --name sh-agent1 -h sh-esm-data-1 -v $BINROOT/agent:/root/agent -v $HOMEPATH/configs/agent.toml:/etc/agent.toml  centos:centos6 bash -c "cd ~ && ./agent -config='/etc/agent.toml'"


sleep 2s

echo -e "\033\033[32m 8.-------> 启动judge \033[0m"
sudo docker run -itd --net=mynet --name judge -v $BINROOT/judge:/root/judge -v /tmp/logs/judgelog:/tmp  centos:centos6 bash -c "cd ~ && ./judge -etcdurls='http://etcd.mynet:2379'"

sleep 2s

echo -e "\033\033[32m 9.-------> 启动convergence \033[0m"
sudo docker run -itd --net=mynet --name convergence -v $BINROOT/convergence:/root/convergence -v /tmp/logs/convergencelog:/tmp  centos:centos6 bash -c "cd ~ && ./convergence -etcdurls='http://etcd.mynet:2379'"

sleep 2s
echo -e "\033\033[32m 10.-------> 启动alarm \033[0m"
sudo docker run -itd --net=mynet --name alarm -v $BINROOT/alarm:/root/alarm  -v /tmp/logs/alarmlog:/tmp centos:centos6 bash -c "cd ~ &&./alarm -endpoint='http://etcd.mynet:2379'"
