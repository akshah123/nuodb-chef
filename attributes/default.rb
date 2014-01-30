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

default[:nuodb][:version] = "2.0.2"
# Set this to something to use a custom download URL  
default[:nuodb][:download_url] = ""
default[:nuodb]["license"] = ""

default[:nuodb]["user"] = "nuodb"
default[:nuodb]["group"] = "nuodb"
default[:nuodb]["install_dir"] = "/opt/nuodb"
default[:nuodb]["config_dir"] = "/etc/nuodb"
default[:nuodb]["data_dir"] = "/opt/nuodb/data"
default[:nuodb]["log_dir"] = "/opt/nuodb/logs"
  
default[:nuodb][:advertiseAlt] = false
default[:nuodb][:altAddr] = ""
default[:nuodb]["brokers"] = ['localhost']
default[:nuodb]["enableAutomation"] = false
default[:nuodb]["enableAutomationBootstrap"] = false
default[:nuodb]["automationTemplate"] = "Minimally Redundant"
default[:nuodb]["is_broker"] = false
default[:nuodb]["domain"] = "domain"
default[:nuodb]["domainPassword"] = "bird"
default[:nuodb]["loglevel"] = "INFO" #  default logging level
default[:nuodb]["port"] = "48004"
default[:nuodb]["portRange"] = "48005"
default[:nuodb]["region"] = "default"
  
#enable basic monitoring via monit
# If you have another monitoring system best to set this to false
default[:nuodb][:monitoring][:enable] = true
default[:nuodb][:monitoring][:alert_email] = "alert@example.com"
default[:nuodb][:monitoring][:mailserver] = "localhost"
  
  

