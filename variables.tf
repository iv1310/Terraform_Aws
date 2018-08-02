variable "aws_region" {
	description = "Region for the Instance"
	default = "ap-northeast-1"
}

variable "aws_vpc" {
	description = "VPC for the Security Group"
	default = "vpc-ac98eec8"
}

variable "aws_vm01_ami" {
	default = "ami-940cdceb"
}

variable "aws_vm02_ami" {
	default = "ami-d2c924b2"
}

variable "aws_subnet" {
	default = "subnet-2a9ea45c"
}

variable "aws_lambda_timeout" {
	default = "50"
}

variable "aws_lambda_runtime" {
	default = "python2.7"
}

variable "aws_lambda_permission_principal" {
	default = "events.amazonaws.com"
}

variable "aws_lambda_permission_action" {
	default = "lambda:InvokeFunction"
}

variable "aws_lambda_permission_statement_id" {
	default = "AllowExecutionFromCloudWatch"
}

variable "aws_iam_role" {
	default = "arn:aws:iam::059793240584:role/ec2_start_stop_role"
}

variable "aws_route53_zone_id" {
	default = "ZAZ0UM9997U0C"
}

variable "aws_route53_type" {
	default = "A"
}

variable "aws_route53_ttl" {
	default = "300"
}

variable "firstname" {
	description = "Enter the participant's first name!"
}
