variable "name"			     { default = "chef-server" }  //EC2 instance name
variable "vpc_id"		     { }  // vpc id
variable "key_name"		     { }  // ssh keypair name
variable "subnet_id"		     { }  // subnet id
variable "ami"			     { }  // ami id
variable "instance_type"	     { }  // instance type
variable "hostname"		     { }  // hostname
variable "private_ip"		     { }  // Private IP
variable "sg_name"		     { }  // Security group name
variable "source_cidr_block"	     { }  // cidr block for ingress rule 
variable "ssh_cidr_block"	     { }  // ssh cidr block
variable "route_zone_id"	     { }  // Route53 zone id
variable "username"		     { }  // Chef server username
variable "first_name"		     { }  // Chef server User Firstname
variable "last_name"		     { }  // Chef server User Lastname
variable "email_id"		     { }  // Chef server User Email id
variable "password"		     { }  // Chef server User Password
variable "org_name"		     { }  // Chef server Organization shortname
variable "full_org_name"	     { }  // Chef server Organization fullname
variable "user"			     { }  // EC2 instance username
variable "private_key"		     { }  // EC2 Private key file location 
variable "vpc_peer_cidr_block" 	     { }  // VPC peer CIDR block
variable "vpc_cidr_block"	     { }  // VPC CIDR block
