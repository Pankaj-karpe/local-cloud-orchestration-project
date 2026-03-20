variable "bucket_name" {
  type    = string
  default = "my-s3-bucket-unique12"
}

variable "dynamodb_name" {
  type    = string
  default = "IPL_Teams"
}

variable "dynamodb_billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "dynamodb_hashKey" {
  type    = string
  default = "TeamId"
}