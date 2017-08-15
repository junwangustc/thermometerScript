source setenv.sh

echo -e "\033\033[32m 1.------->Create Compile  Binary Env\033[0m"
docker run -itd --name CmpEnv  -v $CODEPATH:$WORKPATH -v $BINROOT:$WORKPATH/bin   gogvmenv:v1.8  /bin/bash


echo -e "\033\033[32m 2.-------> Compile agent  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/agent && go install"

echo -e "\033\033[32m 3.-------> Compile gateway  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/gateway && go install"

echo -e "\033\033[32m 4.-------> Compile relay  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/relay && go install"

echo -e "\033\033[32m 5.-------> Compile etcd  Binary \033[0m"
sudo cp /home/vagrant/etcd-v2.3.7-linux-amd64/etcd* /tmp/thermometer/


#echo -e "\033\033[32m 5.5.-------> Compile judgeProxy  Binary \033[0m"
#docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/judgeproxy && go install"



echo -e "\033\033[32m 6.-------> Compile judge  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/judge && go install"

echo -e "\033\033[32m 7.-------> Compile Convergence  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/convergence && go install"

echo -e "\033\033[32m 8.-------> Compile Alarm  Binary \033[0m"
docker exec -it CmpEnv /bin/bash -c "cd ~ &&source .bashrc&&gvm use go1.8 &&cd /root/work/go &&gvm pkgset delete --local&&gvm pkgset create --local &&gvm pkgset use --local && cd /root/work/go/src/github.com/junwangustc/thermometer/cmd/alarm && go install"












docker stop CmpEnv
docker rm CmpEnv
