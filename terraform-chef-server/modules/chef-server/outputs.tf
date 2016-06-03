output "chef_server_private_ip"         { value = "${aws_instance.chef-server.private_ip}" }
output "chef_server_security_group_id"  { value = "${aws_security_group.chef-server.id}" }
output "chef_server_instance_id"        { value = "${aws_instance.chef-server.id}" }
