
NuoDB [Chef](http://www.getchef.com/chef/) Cookbook
===================================================
Installs and configures NuoDB
Lots of great information on NuoDB can be found at: http://dev.nuodb.com/

Requirements
------------
Chef 0.10+

Platform
--------
- Debian, Ubuntu
- CentOS, Red Hat, Fedora, Amazon

Tested on:
- Amazon Linux 2013.9, Ubuntu 12.10, Centos6.4

Using [Vagrant](http://www.vagrantup.com/) with this module
------------------------------
To get started with Vagrant:
* http://docs.vagrantup.com/v2/getting-started/index.html
After starting the vagrant environment:
* You can access the following from the host machine:
** The web console at http://localhost:8080
** The rest API at http://localhost:8888
* Single node environments
** The only node started (db0) will be in Broker mode
** By default Vagrant will start one machine. From the host machine you can connect to the broker at localhost:48004 and subproceseses on localhost:48005-48020
* Multi-node environments
** To use the multi-node scaling capabilities of NuoDB you can start multiple machines in your vagrant environment. Do this by changing one line in the Vagrantfile:
`nodes = {
  "db" => 1 # Change this number to the number of nodes you want to start
}`
** The first node (db0) will be the broker, and all other nodes (db1+) will connect to it.
** Console access will work as above
** Port forwarding of the broker and subprocess connections will be disabled. The only way to connect a client to the environment will be from inside the environment.

Installation of NuoDB using chef-solo
-------------------------------------
* On the host create a file called /var/chef/data.json with the attributes listed below using this [example](https://raw.github.com/nuodb/dbaas/master/solo_install/data.json) as a template
* Download and run the [quickstart file](https://raw.github.com/nuodb/dbaas/master/solo_install/nuodb_install.sh) as sudo or root

Attributes
----------
See `attributes/default.rb` for default values. All values are strings unless otherwise indicated.

* `node[:nuodb][:version]` - What version of NuoDB to install. Download URL is auto created
* `node[:nuodb][:download_url]` - This overrides the auto created download URL with another URL you can specify 
* `node[:nuodb]["license"]` - Your license string obtained from NuoDB at [www.nuodb.com](http://www.nuodb.com)
* `node[:nuodb][:altAddr]` - Specify this if you want other nodes to connect to this server at an address that is not local to the host (i.e. a load balancer, a proxy, an AWS public IP)
* `node[:nuodb]["brokers"]` - Array of strings. All the hosts where you are running the agent in broker node
* `node[:nuodb]["enableAutomation"]` - Boolean. Whether to enable automation on the system database. See [NuoDB manual](http://dev.nuodb.com)
* `node[:nuodb]["enableAutomationBootstrap"]` - Boolean. Should this node bootstrap the system database? See [NuoDB manual](http://dev.nuodb.com)
* `node[:nuodb]["automationTemplate"]` - How resilient should your system database be? Valid options are "Single Host" or "Minimally Redundant"
* `node[:nuodb]["is_broker"]` - Boolean. Should this host be a broker?
* `node[:nuodb]["domain_name"]` - The name of your domain. All nodes in the same cluster should have the same domain name
* `node[:nuodb]["domain_password"]` - The administrative password for your domain. All nodes should have the same password
* `node[:nuodb]["loglevel"]` - Default logging level. Valid levels are, from most to least verbose: ALL, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, OFF
* `node[:nuodb]["port"]` - What port will the agent start on?
* `node[:nuodb]["portRange"]` - Subprocesses of NuoDB use a port range that start at a certain point and increment by one. This is that starting port (usually one port higher than the agent port)
* `node[:nuodb]["region"]` - The name of the region this database lives in
* `node[:nuodb][:webconsole][:port]` - Default port for the web console is 8080
* `node[:nuodb][:webconsole][:brokers]` - Default broker for webconsole to connect to is the same as the agent. You may override this.
* `node[:nuodb][:autoconsole][:port]` - Default autoconsole port is 8888
* `node[:nuodb][:autoconsole][:admin_port]` - Default Autoconsole administration port is 8889
* `node[:nuodb][:autoconsole][:brokers]` - Default broker for autoconsole to connect to is the same as the agent. You may override this.
* `node[:nuodb][:autoconsole][:logfile]` - Default logfile is /opt/nuodb/"var/log/restsvc.log

Enabling basic monitoring via monit. 
If you have another monitoring system best to set this to false
* `node[:nuodb][:monitoring][:enable]` - Boolean. Should Monit be enabled for this node?
* `node[:nuodb][:monitoring][:alert_email]` - The email address to send alerts to
* `node[:nuodb][:monitoring][:mailserver]` - What host is the mail server running on?

These attributes are in the cookbook but cannot be changed with an RPM or dpkg installation, which is the current method. They are included here only for forward compatibility.
* `node[:nuodb]["user"]` - "nuodb"
* `node[:nuodb]["group"]` - "nuodb"
* `node[:nuodb]["install_dir"]` - "/opt/nuodb"
* `node[:nuodb]["config_dir"]` - "/etc/nuodb"
* `node[:nuodb]["data_dir"]` - "/opt/nuodb/data"
* `node[:nuodb]["log_dir"]` - "/opt/nuodb/logs"