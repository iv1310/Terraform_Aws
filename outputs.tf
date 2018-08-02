output "IP-Server" {
	value = "${aws_instance.linus.public_ip}"
}

output "Domain Server" {
	value = "${aws_route53_record.server.fqdn}"
}

output "IP-Monitoring" {
	value = "${aws_instance.linus-2.public_ip}"
}

output "Domain Monitoring" {
	value = "${aws_route53_record.monitoring.fqdn}"
}
