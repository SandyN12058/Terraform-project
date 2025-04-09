output "loadbalancer_dns" {
  value = aws_lb.lb.dns_name
}

output "bastion_host_ip" {
  value = aws_instance.bastion_host.public_ip
}