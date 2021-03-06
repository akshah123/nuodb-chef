#
# Cookbook Name:: nuodb
# Recipe:: default
#
# Copyright 2013, NuoDB, Inc.
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

include_recipe "java"

if node[:nuodb][:download_url].length() == 0
  if platform_family?("debian")
    download_url = "http://download.nuohub.org/nuodb-#{node[:nuodb]['version']}.linux.x64.deb"
  else
    download_url = "http://download.nuohub.org/nuodb-#{node[:nuodb]['version']}.linux.x64.rpm"
  end
else
  download_url = node[:nuodb][:download_url]
end
if platform_family?("debian")
  pkg_provider = Chef::Provider::Package::Dpkg
else
  pkg_provider = Chef::Provider::Package::Rpm
end

artifact = File.basename(download_url)
license_file = File.join(node[:nuodb]['install_dir'], 'license.file')

group node[:nuodb]['group'] do
  action :create
end
user node[:nuodb]['user'] do
  action :create
  home node[:nuodb]['install_dir']
  gid node[:nuodb]['group']
  supports :manage_home => false
end

remote_file "#{Chef::Config[:file_cache_path]}/#{artifact}" do
  source download_url
  mode "0644"
end

package "nuodb" do
  action :install
  provider pkg_provider
  source "#{Chef::Config[:file_cache_path]}/#{artifact}"
end

['data_dir', 'log_dir'].each do |dir|
  directory node[:nuodb][dir] do
    action :create
    owner node[:nuodb]['user']
    group node[:nuodb]['group']
    mode "00755"
  end
end
['etc/default.properties', 'etc/nuodb.config'].each do |file|
  template File.join(node[:nuodb]['install_dir'], file) do
    source file
    mode "0644"
    owner node[:nuodb]['user']
    group node[:nuodb]['group']
    notifies :restart, "service[nuoagent]" if node[:nuodb][:start_service]
  end
end

if node[:nuodb][:start_service]
  service "nuoagent" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end

if node[:nuodb][:is_broker]
  if node[:nuodb]["license"].length > 0
    template license_file do
      source "/license.file"
      mode "0644"
      owner node[:nuodb]['user']
      group node[:nuodb]['group']
      notifies :run, "bash[Load License]"
    end
  end
  bash "Load License" do
    action :nothing
    user node[:nuodb]['user']
    code <<-EOH
      #{node[:nuodb]['install_dir']}/bin/nuodbmgr --broker localhost:#{node[:nuodb]['port']} --password #{node[:nuodb]['domain_password']} --command "apply domain license licenseFile #{license_file}"
    EOH
  end
  #Broker node should also have a web console running
  ['etc/nuodb-rest-api.yml'].each do |file|
    template File.join(node[:nuodb]['install_dir'], file) do
      source file
      mode "0644"
      owner node[:nuodb]['user']
      group node[:nuodb]['group']
      notifies :restart, "service[nuoautoconsole]", :delayed if node[:nuodb][:start_service]
    end
  end
  ['etc/webapp.properties'].each do |file|
    template File.join(node[:nuodb]['install_dir'], file) do
      source file
      mode "0644"
      owner node[:nuodb]['user']
      group node[:nuodb]['group']
      notifies :restart, "service[nuowebconsole]", :delayed if node[:nuodb][:start_service]
    end
  end
  if node[:nuodb][:start_service]
    service "nuoautoconsole" do
      action [ :enable, :start ]
      supports :status => true, :restart => true, :reload => true
    end
    service "nuowebconsole" do
      action [ :enable, :start ]
      supports :status => true, :restart => true, :reload => true
    end
  end
else
  ['etc/nuodb-rest-api.yml', 'etc/webapp.properties'].each do |file|
    template File.join(node[:nuodb]['install_dir'], file) do
      source file
      mode "0644"
      owner node[:nuodb]['user']
      group node[:nuodb]['group']
    end
  end
end
if node[:nuodb][:testdata]
  include_recipe "nuodb::testdata"
end

if node[:nuodb][:monitoring][:enable]
  include_recipe "nuodb::monit"
end

