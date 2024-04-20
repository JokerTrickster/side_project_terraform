# Project Overview
[Frog repository](https://github.com/JokerTrickster/frog_mahjong_game) aws 인프라 구축 

# Installation and Version
```bash
- aws cli  (v2.15.xx)
- terraform (v1.7.5)
- docker (v25.0.3)

```

# Usage
```bash
terraform plan -input=false -var-file=ecs.tfvars
terraform apply -input=false -var-file=ecs.tfvars
```

### Module structure

![Terraform module structure](img/ecs-terraform-modules.png)


# 인프라 구성도
![KakaoTalk_Photo_2024-04-14-18-41-11](https://github.com/JokerTrickster/frog_mahjong_game/assets/140731661/74245fc3-d3cb-4d06-a9c3-022ec4514c8f)