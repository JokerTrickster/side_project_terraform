#!/bin/bash

echo "Terraform 명령어를 선택하세요:"
echo "1) Plan"
echo "2) Apply"
echo "3) Destroy"
read -p "선택 (1/2/3): " choice

case $choice in
  1) terraform plan -input=false -var-file=ecs.tfvars ;;
  2) terraform apply -input=false -var-file=ecs.tfvars ;;
  3) terraform destroy -input=false -var-file=ecs.tfvars ;;
  *) echo "잘못된 입력입니다." ;;
esac
