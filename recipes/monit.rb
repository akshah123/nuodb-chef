# Basic Monit integration

package "monit" do
  action :install
end

["nuodb", "mailformat"].each do |file|
  template "/etc/monit.d/" + file do
    source "monit/" + file
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[monit]", :delayed
  end
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end