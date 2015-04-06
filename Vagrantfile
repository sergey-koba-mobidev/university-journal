# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require './lib/vagrant_extras'
extend VagrantExtras

# check and install required Vagrant plugins
check_plugins(%w(vagrant-hostsupdater vagrant-vbguest vagrant-cachier))

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Using the latest 14.04 Ubuntu Server (LTS)
  vm_box(config)

  config.vm.synced_folder ".", "/vagrant", nfs: true
  config.vm.network "private_network", ip: '192.168.77.41'
  config.vm.provider "virtualbox" do |v|
    v.memory = 2096
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--name", "UniversityJournal"]
  end

  # Set entries in hosts file
  update_hosts_file(config, 'univer.local')

  # Enable cache
  cache_scope(config)

  # Ansible playbook provision
  ansible_playbook_provision(config, 'ansible/univer.yml')
end
