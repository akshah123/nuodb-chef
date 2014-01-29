# Basic Monit integration

package "monit" do
  action :install
end

template "/etc/monit.d/nuodb" do
  source "monit/nuodb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[monit]", :delayed
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end