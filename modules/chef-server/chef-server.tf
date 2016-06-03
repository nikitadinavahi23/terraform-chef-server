# ---------------------------------------------------------------------
# This module will create all the resources for chef-server
#----------------------------------------------------------------------

// Security group
resource "aws_security_group" "chef-server" {
    name = "${var.sg_name}"
    description = "chef-server security group"
    vpc_id = "${var.vpc_id}"

    // allow traffic for TCP 443
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}","${var.vpc_peer_cidr_block}","${var.vpc_cidr_block}"]
    }
    
    // allow traffic for TCP 80
    ingress {
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["${var.source_cidr_block}","${var.vpc_peer_cidr_block}","${var.vpc_cidr_block}"] 
    }

    // allow traffic for ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.ssh_cidr_block}","${var.vpc_cidr_block}"]
    }    

    // allow traffic from dev-voyce-device-vpc
    ingress {
        from_port = 9683
        to_port = 9683 
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_peer_cidr_block}","${var.vpc_cidr_block}"]
    }

    // outbound traffic
    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

}

// Template file for generating Chef server installation script
resource "template_file" "user_data" {
    template = "${file("${path.module}/chef-server.sh.tpl")}"

    vars {
 	hostname       = "${var.hostname}"
	username       = "${var.username}"
	first_name     = "${var.first_name}"
	last_name      = "${var.last_name}"
	email_id       = "${var.email_id}"
	password       = "${var.password}"
	org_name       = "${var.org_name}"
	full_org_name  = "${var.full_org_name}"	
	private_ip     = "${var.private_ip}" 

    }
}

// Chef-server EC2 node
resource "aws_instance" "chef-server" {
    ami           		= "${var.ami}"
    instance_type 		= "${var.instance_type}"
    key_name      		= "${var.key_name}"
    subnet_id     		= "${var.subnet_id}"
    associate_public_ip_address = false
    private_ip			= "${var.private_ip}"
    connection {
	user = "${var.user}"
	type = "ssh"
	private_key = "${file(var.private_key)}"
	timeout = "2m"
    }
    provisioner "remote-exec" {
	inline = [
        "cat <<EOF > /tmp/script.sh",
 	"${template_file.user_data.rendered}",
	"EOF",
        "chmod +x /tmp/script.sh",
        "sudo /tmp/script.sh"	
        ]
    }
    
    vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
    tags      { Name = "${var.name}" }
}

// Route53 Entry
resource "aws_route53_record" "chef-server_private" {
    zone_id = "${var.route_zone_id}"
    name    = "${var.hostname}"
    type    = "A"
    ttl     = "60"
    records = ["${aws_instance.chef-server.private_ip}"]
}
