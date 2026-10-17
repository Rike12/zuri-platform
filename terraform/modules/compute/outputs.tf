output "instance_id" {
  description = "ID of the k3s EC2 instance."
  value       = aws_instance.k3s.id
}

output "public_ip" {
  description = "Public IP address of the k3s EC2 instance."
  value       = aws_instance.k3s.public_ip
}
