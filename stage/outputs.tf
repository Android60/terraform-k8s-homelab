
output "ansible-command" {
  description = "You can run ansible playbook with that command"
  value       = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_user} -i ansible/hosts.cfg ansible/main.yml"
}

