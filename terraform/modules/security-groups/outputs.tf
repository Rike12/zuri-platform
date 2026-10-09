output "k3s_security_group_id" {
  description = "Security group ID for the k3s host."
  value       = aws_security_group.k3s.id
}
