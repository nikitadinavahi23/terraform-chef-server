#!/bin/bash
yum -y update
sed -i s/HOSTNAME=.*/HOSTNAME=${hostname}/g /etc/sysconfig/network
echo "127.0.0.1 ${hostname} ${hostname}.localdomain" | sudo tee --append /etc/hosts
hostname ${hostname}

# Add packagecloud repository
curl -sSf "https://packagecloud.io/install/repositories/chef/stable/config_file.repo?os=aws&dist=6&source=script" | sudo tee --append /etc/yum.repos.d/chef_stable.repo

# Install chef-server
yum install -y chef-server-core-12.4.1-1.el6.x86_64
chef-server-ctl reconfigure

# Chef server configuration
echo "server_name = \"${private_ip}\"" >> /etc/opscode/chef-server.rb
echo "api_fqdn server_name" >> /etc/opscode/chef-server.rb
echo "bookshelf['vip'] = server_name" >> /etc/opscode/chef-server.rb
echo "nginx['url'] = \"https://#{server_name}\"" >> /etc/opscode/chef-server.rb
echo "nginx['server_name'] = server_name" >> /etc/opscode/chef-server.rb

chown opscode:root /etc/opscode/chef-server.rb

# Configure chef-server
chef-server-ctl user-create ${username} ${first_name} ${last_name} ${email_id} "${password}" --filename ${username}.pem
chef-server-ctl org-create ${org_name} "${full_org_name}" --association_user ${username} --filename ${org_name}-validator.pem
yum install -y chef-manage-2.2.0-1.el6.x86_64
chef-server-ctl reconfigure
opscode-manage-ctl reconfigure
