output "pub_sub_id" {
    value = aws_subnet.pub-sub.id
}

output "priv_sub_id" {
    value = aws_subnet.priv-sub.id
}

output "security_group_id" {
    value = aws_security_group.tf-sg.id
}

output "key_name" {
    value = aws_key_pair.key.key_name
}
