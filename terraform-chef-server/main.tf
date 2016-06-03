#----------------------------------------------------------------------------------
# This Main template will use chef-server module and create compute resources
#----------------------------------------------------------------------------------

// Amazon Web Service Provider
provider "aws" {
    region                   = "${var.region}"
    profile                  = "${var.profile}"
}

// Chef-Server module
module "chef-server" {
    source = "./modules/chef-server"
    
    name		      = "${var.name}"
    vpc_id		      = "${var.vpc_id}"
    key_name		      = "${var.key_name}"
    subnet_id		      = "${var.subnet_id}"
    ami			      = "${var.ami}"
    user		      = "${var.user}"
    private_key		      = "${var.private_key}"
    instance_type	      = "${var.instance_type}"
    hostname		      = "${var.name}"
    private_ip		      = "${var.private_ip}"
    sg_name		      = "${var.sg_name}"
    source_cidr_block	      = "${var.source_cidr_block}"
    ssh_cidr_block	      = "${var.ssh_cidr_block}"
    route_zone_id	      = "${var.route_zone_id}"
    username		      = "${var.username}"
    first_name		      = "${var.first_name}"
    last_name		      = "${var.last_name}"
    email_id		      = "${var.email_id}"
    password		      = "${var.password}"
    org_name		      = "${var.org_name}"
    full_org_name	      = "${var.full_org_name}"
    vpc_peer_cidr_block	      = "${terraform_remote_state.vpc.output.vpc_cidr}"
    vpc_cidr_block	      = "${var.vpc_cidr_block}"
 
}
