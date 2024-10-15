# A name to describe the environment we're creating.
environment = "dev"

# The name of the ECS cluster.
cluster = "service"

# The AWS-CLI profile for the account to create resources in.
aws_profile = "default"

# The AWS region to create resources in.
aws_region = "ap-northeast-2"

# The AMI to seed ECS instances with.
# Leave empty to use the latest Linux 2 ECS-optimized AMI by Amazon.
aws_ecs_ami = "ami-010173e0f7a62bfbf"

# The IP range to attribute to the virtual network.
# The allowed block size is between a /16 (65,536 addresses) and /28 (16 addresses).
vpc_cidr = "10.12.0.0/16"

# The IP ranges to use for the public subnets in your VPC.
# Must be within the IP range of your VPC.
public_subnet_cidrs = ["10.12.101.0/24", "10.12.106.0/24"]

# The IP ranges to use for the private subnets in your VPC.
# Must be within the IP range of your VPC.
private_subnet_cidrs = ["10.12.1.0/24", "10.12.6.0/24"]

# The AWS availability zones to create subnets in.
# For high-availability, we need at least two.
availability_zones = ["ap-northeast-2a", "ap-northeast-2b"]

# Maximum number of instances in the ECS cluster.
max_size = 3

# Minimum number of instances in the ECS cluster.
min_size = 2

# Ideal number of instances in the ECS cluster.
desired_capacity = 3

# Size of instances in the ECS cluster.
# t4g.micro	USD 0.0084	최대 5기가비트
instance_type = "t4g.small"
