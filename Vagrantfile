# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  
  PROJECT_DIR = "~/Projects/ckanext-helloworld"
  CKAN_PLUGIN = "hello"
  
  config.vm.box = "fjunior/ckan2.9"
  
  config.vm.synced_folder "etc/", "/etc/ckan/default"
  config.vm.synced_folder "src/", "/usr/lib/ckan/default/src"
  config.vm.synced_folder PROJECT_DIR, "/home/vagrant/project"

  config.vm.network "private_network", ip: "192.168.33.60"

  config.vm.provision "shell", path: "setup.sh", privileged: false, env: {"CKAN_PLUGIN": CKAN_PLUGIN}
  Dir.glob('extensions/*.sh') do |ckanext|
    config.vm.provision "shell", path: ckanext, privileged: false
  end

end
