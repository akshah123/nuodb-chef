#!/bin/bash

if [ ! -f /var/chef/data.json ];
then
  echo "Please create a /var/chef/data.json file that looks like https://raw.github.com/nuodb/dbaas/master/solo_install/data.json"
  exit(2)
fi

# install chef
if [ `which git` ];
then
    echo "git ok";
else
    if [  `which yum` ];
    then
        sudo yum -y install git;
    else
        sudo apt-get -y install git;
    fi;
fi;
curl -L https://www.opscode.com/chef/install.sh | bash
git clone https://github.com/nuodb/nuodb-chef.git /var/chef/cookbooks/nuodb
git clone https://github.com/socrata-cookbooks/java.git /var/chef/cookbooks/java
git clone https://github.com/opscode-cookbooks/yum-epel.git /var/chef/cookbooks/yum-epel
git clone https://github.com/opscode-cookbooks/yum.git /var/chef/cookbooks/yum
chef-solo -j /var/chef/data.json