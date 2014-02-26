# -*- mode: ruby -*-
# vi: set ft=ruby :

## User editable
# How many nodes do you want?
# Any more than 2 requires a license
nodes = {
  "db" => 2
}
private_network = "192.168.50.10"

### End User editable

puts "To access the web console go to http://localhost:9000"

servers = Array.new
subnets = private_network.split('.')
nuo_config = {
  "brokers" => [private_network]
}
nodes.each_key do |node_type|
  number_of_nodes = nodes[node_type].to_i
  (1..number_of_nodes).each do |i|
    server = Hash.new
    server['vagrantname'] = [node_type, i].join()
    server['hostname'] = [server['vagrantname'], ".vagrantup.com"].join()
    server['ipaddress'] = subnets.join('.')
    if nuo_config['brokers'].include?(server['ipaddress'])
      server['chef_json'] = { :nuodb => { "is_broker" => true, "brokers" => nuo_config['brokers'], "testdata" => true } }
    else
      server['chef_json'] = { :nuodb => { "brokers" => nuo_config['brokers'], "testdata" => false } }
    end
    subnets[3] = subnets[3].to_i + 1
    servers << server
  end
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos6.4-chef"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.4_chef-provisionerless.box"
  #config.vm.box = "ubuntu12.10-chef"
  #config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.10_chef-provisionerless.box"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    #   vb.gui = true
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
  config.cache.auto_detect = true
  servers.each do |server|
    config.vm.define server['vagrantname'] do | client |
      client.vm.hostname = server['hostname']
      client.vm.network "private_network", ip: server['ipaddress']
      if server['ipaddress'] == private_network
        client.vm.network "forwarded_port", guest: 8080, host: 9000
      end
      if config.vm.box.include?("ubuntu")
        client.vm.provision "shell", inline: "sudo apt-get update"
      end
      client.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["#{File.expand_path("..",Dir.pwd)}"]
        if server.has_key?("chef_json")
          chef.json = server['chef_json']
        end
        chef.add_recipe('chef-solo-search')
        chef.add_recipe "nuodb"
      end
    end
  end
end
