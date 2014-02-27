# Basic Monit integration

if platform_family?("debian")
  monit_conf_dir = "/etc/monit/conf.d/"
else
  monit_conf_dir = "/etc/monit.d/"
  # Monit comes out of here for CentOS, RHEL
  include_recipe "yum-epel"
end

package "monit" do
  action :install
end

["nuodb", "mailformat"].each do |file|
  template monit_conf_dir + file do
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