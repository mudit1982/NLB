output "id" {
  value = aws_security_group.security_groups.id
}    

# output "security_group_id" {
#   value = "${concat(aws_security_group.security_groups.*.id, tolist([""]))}"
# }    
