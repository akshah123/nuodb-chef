#
# Cookbook Name:: nuodb
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A lot of these fields are described in the NuoDB documentation at http://dev.nuodb.com/

default[:nuodb][:version] = "2.0.3"
default[:nuodb][:download_url] = "" # Set this to something to use a custom download URL. Will override the version set above.
default[:nuodb]["license"] = ""

  
#With RPM or DEB installation these fields really don't do anything.
default[:nuodb]["user"] = "nuodb"
default[:nuodb]["group"] = "nuodb"
default[:nuodb]["install_dir"] = "/opt/nuodb"
default[:nuodb]["config_dir"] = "/etc/nuodb"
default[:nuodb]["data_dir"] = "/opt/nuodb/data"
default[:nuodb]["log_dir"] = "/opt/nuodb/logs"
  
default[:nuodb][:altAddr] = "" # Use this if you want nodes to talk on another IP address not attached to the machine... i.e. AWS with public IP, or load balancer
default[:nuodb][:balancer] = "RegionBalancer" # balance load across multiple regions if you have them
default[:nuodb]["brokers"] = ['localhost'] # Array of what the broker addresses are
default[:nuodb]["enableAutomation"] = false # See NuoDB manual at 
default[:nuodb]["enableAutomationBootstrap"] = false
default[:nuodb]["automationTemplate"] = "Minimally Redundant"
default[:nuodb]["is_broker"] = false # Should this host be a broker?
default[:nuodb]["domain_name"] = "domain"
default[:nuodb]["domain_password"] = "bird"
default[:nuodb]["loglevel"] = "INFO" #  default logging level
default[:nuodb]["port"] = "48004" # What port to run the agent on
default[:nuodb]["portRange"] = "48005" # What ports do the sub-processes bind to? This is the starting address for the first one, subsequent processes increment from there
default[:nuodb][:webconsole][:port] = 8080 
default[:nuodb][:autoconsole][:port] = 8888
default[:nuodb][:autoconsole][:admin_port] = 8889
default[:nuodb][:autoconsole][:brokers] = node[:nuodb][:brokers]
default[:nuodb][:autoconsole][:logfile] = "var/log/restsvc.log"
default[:nuodb]["region"] = "default" # Do you want a multi-region database? If so name this region.

  
#enable basic monitoring via monit
# If you have another monitoring system best to set this to false
default[:nuodb][:monitoring][:enable] = true
default[:nuodb][:monitoring][:alert_email] = "alert@example.com"
default[:nuodb][:monitoring][:mailserver] = "localhost"
  
  

