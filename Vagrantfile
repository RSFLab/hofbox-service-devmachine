# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2204"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 4096
  end

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 4096
  end
  
  config.vm.provision :file,
    source: "provision/mgmt-hub-config.txt", destination: "/home/vagrant/"
  config.vm.provision :shell, 
    path: "provision/bootstrap.sh"

  config.vm.synced_folder "./horizon-service-examples", "/home/vagrant/horizon-service-examples",  type: "rsync"#, disabled: true
  config.vm.network :forwarded_port, guest: 80, host: 4567

end
