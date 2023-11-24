resource "aws_key_pair" "ryankeypair" {
  key_name   = "ryankeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  lifecycle {
    ignore_changes = [public_key]
  }
}

