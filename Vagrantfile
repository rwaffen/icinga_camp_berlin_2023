# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  $bootstrap_script = <<-SCRIPT
    source /etc/os-release

    if [ "${NAME}" == "Ubuntu" ]; then
      hostnamectl set-hostname $HOSTNAME.example.com
      wget -4 https://apt.puppetlabs.com/puppet7-release-$UBUNTU_CODENAME.deb
      dpkg -i puppet7-release-$UBUNTU_CODENAME.deb
      apt update -y
      apt install -y puppet-agent

      rm -vf /etc/puppetlabs/code/environments/production/*.dpkg-dist
      rm -vf /etc/puppetlabs/code/environments/production/*.dpkg-new
    fi

    # set names in /etc/hosts
    /opt/puppetlabs/bin/puppet apply /vagrant/scripts/vagrant_apply_me.pp
  SCRIPT

  config.vm.define 'puppet' do |puppet|
    puppet.vm.hostname = 'puppet.example.com'
    puppet.vm.box      = 'ubuntu/focal64' # Ubuntu 20.04
    puppet.vm.network :private_network, ip: '192.168.0.2'
    puppet.vm.synced_folder '.', '/etc/puppetlabs/code/environments/production'
    puppet.vm.synced_folder '.', '/vagrant'

    puppet.vm.provider 'virtualbox' do |vb|
      vb.cpus = 4
      vb.memory = '4096'
    end

    $puppet_script = <<-SCRIPT
      puppet resource package puppetserver ensure=installed
      puppet resource file /etc/puppetlabs/puppet/autosign.conf ensure=file content='*'
      puppet resource service puppetserver ensure=running
      sleep 10
      puppet agent -t || true
    SCRIPT

    puppet.vm.provision :shell, inline: $bootstrap_script
    puppet.vm.provision :shell, inline: $puppet_script
  end

  config.vm.define 'icinga' do |icinga|
    icinga.vm.hostname = 'icinga.example.com'
    icinga.vm.box = 'ubuntu/jammy64' # Ubuntu 22.04
    icinga.vm.network :private_network, ip: '192.168.0.3'
    icinga.vm.synced_folder '.', '/vagrant'
    icinga.vm.provision :shell, inline: $bootstrap_script
  end

  config.vm.define 'agent1' do |agent1|
    agent1.vm.hostname = 'agent1.example.com'
    agent1.vm.box = 'ubuntu/jammy64' # Ubuntu 22.04
    agent1.vm.network :private_network, ip: '192.168.0.4'
    agent1.vm.synced_folder '.', '/vagrant'
    agent1.vm.provision :shell, inline: $bootstrap_script
  end

end
