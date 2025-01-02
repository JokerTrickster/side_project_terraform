#!/bin/bash

# 기존 Docker 설치 제거 및 업데이트
sudo rm -f /usr/libexec/docker/cli-plugins/docker-buildx
sudo rm -f /usr/local/lib/docker/cli-plugins/docker-buildx
sudo rm -f ~/.docker/cli-plugins/docker-buildx

# Docker의 공식 GPG 키 추가
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 패키지 목록 업데이트 및 Docker 및 관련 플러그인 설치
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 데몬 시작 및 활성화
sudo systemctl start docker
sudo systemctl enable docker

# Docker 사용을 위해 현재 사용자를 docker 그룹에 추가
sudo usermod -aG docker ubuntu

# AWS CLI 설치
sudo apt-get install -y awscli

# Go 언어 설치
sudo apt-get install -y golang-go
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile

# Prometheus 설치 및 실행
mkdir /home/ubuntu/prometheus && cd /home/ubuntu/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.6.1/prometheus-2.6.1.linux-arm64.tar.gz
tar xzvf prometheus-2.6.1.linux-arm64.tar.gz
cd prometheus-2.6.1.linux-arm64
nohup ./prometheus &

# 필요한 패키지 설치 (Grafana를 위해)
sudo apt-get install -y adduser libfontconfig1 musl

# Grafana 설치 및 시작
mkdir /home/ubuntu/grafana && cd /home/ubuntu/grafana
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.1.0_arm64.deb
sudo dpkg -i grafana-enterprise_11.1.0_arm64.deb
sudo systemctl start grafana-server

# Loki 설치 및 실행
mkdir /home/ubuntu/loki && cd /home/ubuntu/loki
wget https://github.com/grafana/loki/releases/download/v2.6.1/loki-linux-arm64.zip
sudo apt install unzip
unzip loki-linux-arm64.zip
wget https://raw.githubusercontent.com/grafana/loki/v2.6.1/cmd/loki/loki-local-config.yaml
nohup ./loki-linux-arm64 -config.file=loki-local-config.yaml &

# Redis 및 MySQL 서버 설치
sudo apt-get install -y redis-server
sudo apt-get install -y mysql-server

# 스크립트 종료
exit 0