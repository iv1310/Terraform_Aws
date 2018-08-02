# Lambda Function Starting Instances
resource "aws_lambda_function" "test_lambda" {
	filename = "lambda_function_payload.zip"
	function_name = "stopEC2Instances-sepractest-${var.firstname}"
	role = "${var.aws_iam_role}"
	handler = "main.handler"
	source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
	runtime = "${var.aws_lambda_runtime}"
	timeout = "${var.aws_lambda_timeout}"
	environment {
		variables= {
			ids = "${aws_instance.linus.id}"
		}
		variables= {
			id  = "${aws_instance.linus-2.id}"
		}
	}
	depends_on = ["aws_instance.linus","aws_instance.linus-2"]
	tags {
		Project = "infra-prac-test"
	}
}
resource "aws_cloudwatch_event_rule" "schedule" {
	name = "Scheduling-${var.firstname}"	
	schedule_expression = "cron(0 11 * * ? *)"
	depends_on = ["aws_lambda_function.test_lambda"]
}
resource "aws_cloudwatch_event_target" "target" {
	target_id = "target"
	rule = "${aws_cloudwatch_event_rule.schedule.name}"
	arn = "${aws_lambda_function.test_lambda.arn}"
}
resource "aws_lambda_permission" "lambda_function" {
	statement_id = "${var.aws_lambda_permission_statement_id}"
	action = "${var.aws_lambda_permission_action}"
	function_name = "${aws_lambda_function.test_lambda.function_name}"
	principal = "${var.aws_lambda_permission_principal}"
	source_arn = "${aws_cloudwatch_event_rule.schedule.arn}"
}


# Lambda Function Stopping Instances
resource "aws_lambda_function" "lambda_function2" {
	filename = "lambda_function_payload2.zip"
	function_name = "startEC2Instances-sepractest-${var.firstname}"
	role = "${var.aws_iam_role}"
	handler = "function.handler"
	source_code_hash = "${base64sha256(file("lambda_function_payload2.zip"))}"
	runtime = "${var.aws_lambda_runtime}"
	timeout = "${var.aws_lambda_timeout}"
	environment {
		variables= {
			ids = "${aws_instance.linus.id}"
		}
		variables= {
			id = "${aws_instance.linus-2.id}"
		}
	}
	tags {
		Project = "infra-prac-test"
	}
}
resource "aws_cloudwatch_event_rule" "schedule2" {
	name = "Scheduling-Monitoring-${var.firstname}"	
	schedule_expression = "cron(0 3 * * ? *)"
	depends_on = ["aws_lambda_function.lambda_function2"]
}
resource "aws_cloudwatch_event_target" "target2" {
	target_id = "target"
	rule = "${aws_cloudwatch_event_rule.schedule2.name}"
	arn = "${aws_lambda_function.lambda_function2.arn}"
}
resource "aws_lambda_permission" "lambda_function_permission" {
	statement_id = "${var.aws_lambda_permission_statement_id}"
	action = "${var.aws_lambda_permission_action}"
	function_name = "${aws_lambda_function.lambda_function2.function_name}"
	principal = "${var.aws_lambda_permission_principal}"
	source_arn = "${aws_cloudwatch_event_rule.schedule2.arn}"
}


# Create Instance 
resource "aws_security_group" "test" {
	name = "main-security-group-${var.firstname}"
	tags {
		Security = "Group"
	}
	vpc_id = "${var.aws_vpc}"
}
resource "aws_security_group" "monitoring" {
	name = "monitoring-${var.firstname}"
	tags {
		Security = "Group"
	}
	vpc_id = "${var.aws_vpc}"
}
resource "aws_security_group_rule" "test-1" {
	security_group_id = "${aws_security_group.test.id}"
	type = "ingress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	self = "true"
}
resource "aws_security_group_rule" "test-2" {
	security_group_id = "${aws_security_group.test.id}"
	type = "ingress"

	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "test-3" {
	security_group_id = "${aws_security_group.test.id}"
	type = "ingress"

	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "test-4" {
	security_group_id = "${aws_security_group.test.id}"
	type = "egress"

	from_port = 0
	to_port = 0
	protocol = -1
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "test-5" {
	security_group_id = "${aws_security_group.test.id}"
	type = "ingress"

	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "test-6" {
	security_group_id = "${aws_security_group.test.id}"
	type = "ingress"

	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_instance" "linus" {
	ami = "${var.aws_vm01_ami}"
	instance_type = "t2.micro"
	key_name = "terraform"
	subnet_id = "${var.aws_subnet}"
	vpc_security_group_ids = ["${aws_security_group.test.id}"]
	tags {
		Name = "Sepractest-vm01-${var.firstname}",
		Project = "infra-prac-test"
	}
	depends_on = ["aws_security_group.test"]
}
resource "aws_security_group_rule" "monitor" {
	security_group_id ="${aws_security_group.monitoring.id}"
	type = "ingress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	self = "true"
}
resource "aws_security_group_rule" "ssh" {
	security_group_id = "${aws_security_group.monitoring.id}"
	type = "ingress"
	
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "http" {
	security_group_id = "${aws_security_group.monitoring.id}"
	type = "ingress"

	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "monitor-2" {
	security_group_id = "${aws_security_group.monitoring.id}"
	type = "egress"

	from_port = 0
	to_port = 0
	protocol = -1
	cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_instance" "linus-2" {
	ami = "${var.aws_vm01_ami}"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.monitoring.id}"]
	key_name = "terraform"
	subnet_id = "${var.aws_subnet}"
	tags {
		Name = "Sepractest-vm02-${var.firstname}",
		Project = "infra-prac-test"
	}
	depends_on = ["aws_security_group.monitoring"]
}


#Create DNS 
resource "aws_route53_record" "server" {
	zone_id = "${var.aws_route53_zone_id}"
	name = "sepractest-${var.firstname}"
	type = "${var.aws_route53_type}"
	ttl = "${var.aws_route53_ttl}"
	records = ["${aws_instance.linus.public_ip}"]
	depends_on = ["aws_instance.linus","aws_instance.linus-2"]
}
resource "aws_route53_record" "monitoring" {
	zone_id = "${var.aws_route53_zone_id}"
	name = "sepractest-monitoring-${var.firstname}"
	type = "${var.aws_route53_type}"
	ttl = "${var.aws_route53_ttl}"
	records = ["${aws_instance.linus-2.public_ip}"]
	depends_on = ["aws_instance.linus","aws_instance.linus-2"]
}


#Create remote state
terraform {
	backend "s3" {
		bucket = "gl-intern-terraform"
		region = "us-west-2"
		key = "sepractest/terraform.key"
		dynamodb_table = "dynamodb"
	}
}

#Create locking state
resource "aws_dynamodb_table" "dynamodb-terraform" {
	name = "dynamodb"
	hash_key = "LockID"
	read_capacity = 20
	write_capacity = 20
	attribute {
		name = "LockID"
		type = "S"
	}
	tags {
		Name = "Locking state"
	}
}
