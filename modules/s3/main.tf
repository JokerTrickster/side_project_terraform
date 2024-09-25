resource "aws_s3_bucket" "dev-food-recommendation" {
  bucket = var.dev-food-recommendation

  tags = {
    Name        = "dev-food-recommendation"
    Environment = "dev"
  }
}


resource "aws_s3_bucket" "dev-frog" {
  bucket = var.dev-frog

  tags = {
    Name        = "dev-frog"
    Environment = "dev"
  }
}

