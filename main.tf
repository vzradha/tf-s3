provider "aws" {
	region = "ap-southeast-2"
}

resource "aws_s3_bucket" "tf-state" {
	bucket = "test-tf-s3-902374903247"
	versioning {
		enabled = true
	}
	server_side_encryption_configuration {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm = "AES256"
			}
		}
	}
}

terraform {
	backend "s3" {
		bucket = "test-tf-s3-902374903247"
		key = "test/terrform.state"
		region = "ap-southeast-2"

	}
}
resource "aws_vpc" "multi-cloud-k8-demo" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-multi-cloud-k8-demo-node",
    "kubernetes.io/cluster/test", "shared",
  )
}

resource "aws_subnet" "multi-cloud-k8-demo" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.multi-cloud-k8-demo.id
  map_public_ip_on_launch = true  
  tags = map(
    "Name", "terraform-multi-cloud-k8-demo-node",
    "kubernetes.io/cluster/test", "shared",
  )
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.multi-cloud-k8-demo.id

  tags = {
    Name = "multi-cloud-k8-demo"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.multi-cloud-k8-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = aws_subnet.multi-cloud-k8-demo.*.id[count.index]
  route_table_id = aws_route_table.demo.id
}
resource "aws_subnet" "vault-pki-demo-public" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.vault-pki-demo.id
  map_public_ip_on_launch = true  
  tags = map(
    "Name", "terraform-vault-pki-demo-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}
