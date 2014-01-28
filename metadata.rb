name             "nuodb"
maintainer       "NuoDB"
maintainer_email "rkourtz@nuodb.com"
license          "Apache 2.0"
description      "Installs/Configures nuodb"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

#%w{ java jpackage openssl }.each do |cb|
#  depends cb
#end
depends "java"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "nuodb::default", "Installs and configures Nuodb"