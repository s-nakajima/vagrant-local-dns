# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  #config.hostmanager.enabled = false
  #config.hostmanager.manage_host = true
  #config.hostmanager.manage_host = false
  #config.hostmanager.ignore_private_ip = true


  # Setup vm
  config.vm.define 'default', primary: true do |node|
    node.vm.box = 'local-dns'
    node.vm.box_url = 'https://nc3packages.nakazii-co.jp/local-dns.json'

    node.vm.network :forwarded_port, guest: 22, host: 2220, id: 'ssh'

    node.vm.network :public_network, ip: '192.168.1.200'
    #node.vm.network :private_network, ip: '10.0.0.20'

    node.vm.hostname = 'local-dns'

    #node.vm.provision :hosts do |provisioner|
    #  #provisioner.autoconfigure = false
    #  provisioner.add_host '10.0.0.51', ['app-02', 'sample1.local-edumap.jp']
    #end

    node.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.memory = 2048
    end

    node.vm.synced_folder './tools', '/var/www/vagrant',
    :create => true, :owner=> 'vagrant', :group => 'vagrant'

    node.vm.provision "shell", privileged: true, inline: <<-SHELL
        if [ ! -f /home/vagrant/.build_finish ]; then
            bash /var/www/vagrant/environment/build.sh
        fi
    SHELL

    node.vm.provision "shell2", type: "shell", privileged: true, run: "always", inline: <<-SHELL
        if [ -f /home/vagrant/.build_finish ]; then
            cp -f /var/www/vagrant/environment/hosts-dnsmasq /etc/hosts-dnsmasq

            systemctl disable systemd-resolved
            systemctl mask systemd-resolved
            systemctl stop systemd-resolved
            systemctl unmask systemd-resolved
            systemctl enable systemd-resolved
            systemctl restart dnsmasq
            systemctl status dnsmasq

            ip addr show
        fi
    SHELL
  end
end
