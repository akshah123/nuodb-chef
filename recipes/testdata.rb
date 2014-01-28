testdata_dir = File.join(node[:nuodb]['install_dir'], "testdata")
sqlfile = File.join(testdata_dir, "import.sql")

[testdata_dir].each do |dir|
  directory dir do
    action :create
    owner node[:nuodb]['user']
    group node[:nuodb]['group']
    mode "00755"
  end
end

template File.join(testdata_dir, "nuomgr_import") do
  source "/testdata/nuomgr_import"
  owner node[:nuodb]['user']
  group node[:nuodb]['group']
  mode "00644"
end

unless File.exists?(File.join(node[:nuodb]['data_dir'], "testdb"))
  bash "Create Processes" do
    user node[:nuodb]['user']
    cwd testdata_dir
    code <<-EOH
      #{node[:nuodb]['install_dir']}/bin/nuodbmgr --broker #{node[:nuodb]['brokers'][0]} --password #{node[:nuodb]['domainPassword']} --file #{File.join(testdata_dir, "nuomgr_import")}
    EOH
  end
end

unless File.exists?(sqlfile)
  bash "Generate testdata" do
    user node[:nuodb]['user']
    cwd testdata_dir
    code <<-EOH
      echo "CREATE TABLE IF NOT EXISTS testdb.test (ID integer NOT NULL AUTO_INCREMENT, HOST string, VALUE string);" > #{sqlfile}
      for i in `seq 1 2000`;
      do 
        echo "INSERT INTO testdb.test (VALUE) VALUES ('#{node['fqdn']}', '`echo $RANDOM | openssl md5 | awk '{print \$2}'`');" >> #{sqlfile}; 
      done;
    EOH
  end
  bash "Import testdata" do
    user node[:nuodb]['user']
    cwd testdata_dir
    code <<-EOH
      #{node[:nuodb]['install_dir']}/bin/nuosql testdb@#{node[:nuodb]['brokers'][0]} --user dba --password dba --file #{sqlfile}
    EOH
  end
end