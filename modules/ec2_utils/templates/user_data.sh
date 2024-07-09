#!/bin/bash

# Docker 설치
sudo apt-get update
sudo apt-get install -y docker.io

# Docker 사용을 위해 현재 사용자를 docker 그룹에 추가
sudo usermod -aG docker ubuntu

# AWS CLI 설치
sudo apt-get install -y awscli

# Go 언어 설치
sudo apt-get install -y golang-go 
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile


# 스크립트 종료
exit 0
