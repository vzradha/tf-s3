provider "aws" {
	region = "ap-southeast-2"
}

terraform {
	backend "s3" {
		bucket = "test-tf-s3-902374903247"
		key = "test/terrform.state"
		region = "ap-southeast-2"

	}
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

