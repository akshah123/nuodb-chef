
NuoDB [Chef](http://www.getchef.com/chef/) Cookbook
===================================================
Installs and configures NuoDB

Requirements
------------
Chef 0.10+

Platform
--------
- Debian, Ubuntu
- CentOS, Red Hat, Fedora, Amazon

Tested on:
- Amazon

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