# -*- mode: ruby -*-
# vi: set ft=ruby :

## User editable
# How many nodes do you want?
# Any more than 2 requires a license
# If you want to connect to the vagrant environment from your host machine then you should only use one node for reasons explained more in the README
# If you want to create a multinode environment then any client that accesses the database will need to be inside the environment.

license = "" # optional. Only needed for > 2 nodes
nodes = {
  "db" => 1
}
private_network = "192.168.50.10"
package_url = ""  # optional. If blank we will use the latest production release

### End User editable

servers = Array.new
subnets = private_network.split('.')
nuo_config = {
  "brokers" => [[private_network,"48004"].join(":")]
}
multinode = false
nodes.each_key do |node_type|
  number_of_nodes = nodes[node_type].to_i
  if number_of_nodes > 1
    multinode = true
  end
  (0..number_of_nodes-1).each do |i|
    server = Hash.new
    server['vagrantname'] = [node_type, i].join()
    server['hostname'] = [server['vagrantname'], ".vagrantup.com"].join()
    server['ipaddress'] = subnets.join('.')
    server['agent_port'] = 48004 + (i * 100)
    server['port_start'] = server['agent_port'] + 1
    server['port_end'] = server['port_start'] + 10
    if nuo_config['brokers'].include?([server['ipaddress'],server['agent_port']].join(":"))
      server['chef_json'] = { :nuodb => { "is_broker" => true, "brokers" => nuo_config['brokers'], "testdata" => true, "enableAutomation" => true, "enableAutomationBootstrap" => true } }
    else
      server['chef_json'] = { :nuodb => { "brokers" => nuo_config['brokers'], "testdata" => false } }
    end
    if not multinode
      # if we are a single node we can tell the Broker to broadcast its connection address as the loopback device- that way when clients connect from the host they will be port forwarded to the VM
      # This trick breaks down quickly when you have multiple nodes.
      server['chef_json'][:nuodb]['altAddr'] = "127.0.0.1"
    end
    if package_url != ""
      server['chef_json'][:nuodb][:download_url] = package_url
    end
    if license != ""
      server['chef_json'][:nuodb][:license] = license
    end
    server['chef_json'][:nuodb][:port] = server['agent_port']
    server['chef_json'][:nuodb]['portRange'] = server['port_start'] 
    subnets[3] = subnets[3].to_i + 1
    servers << server
  end
end

puts "================================================================================"
puts "Once the vagrant environment has booted successfully:"
puts "To access the web console from your host machine go to http://localhost:8080"
puts "To access the REST API/Automation console from your host machine go to http://localhost:8888"
if not multinode
  puts "To access the broker from your host point your client to localhost:48004"
else
  puts "In multinode setups connecting to the database from the host machine is disabled."
  puts "To access the broker from inside the environment point your client to " + private_network + ":48004"
end
puts "================================================================================"
puts

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
        # We know this is the fist machine, and also the broker.
        client.vm.network "forwarded_port", guest: 8080, host: 8080
        client.vm.network "forwarded_port", guest: 8888, host: 8888
      end
      if server.has_key?('port_start') and server.has_key?('port_end') and not multinode
        (server['agent_port']..server['port_end']).each do |i|
          client.vm.network "forwarded_port", guest: i, host: i
        end
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

