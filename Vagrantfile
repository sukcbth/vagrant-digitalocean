Vagrant.configure("2") do |config|

	config.vm.synced_folder ".", "/vagrant", type: "rsync"
	
	config.vm.provider :digital_ocean do |provider, override|
	  override.ssh.private_key_path = '~/.ssh/id_rsa'
	  override.vm.box = 'digital_ocean'
	  override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
	  override.nfs.functional = false
	  override.vm.allowed_synced_folder_types = :rsync
	
	  provider.token = ENV['DIGITALOCEANTOKEN']  # Remember to set the environment variable DIGITALOCEAN-TOKEN before running
	  provider.image = 'ubuntu-18-04-x64'
	  provider.region = 'nyc1'
	  provider.size = 's-1vcpu-1gb'
	  provider.setup = false
	end

	config.vm.provider "virtualbox" do |provider, override|
		override.vm.box = "bento/ubuntu-18.04"
	end

	config.vm.provision "shell", inline: <<-SHELL
    	sudo wget https://apt.puppetlabs.com/puppet5-release-$(lsb_release -cs).deb
    	sudo dpkg -i puppet5-release-$(lsb_release -cs).deb
    	sudo apt-get -qq update
    	sudo apt-get install -y puppet-agent
  	SHELL

	config.vm.define "appserver" do |appserver|
		appserver.vm.hostname = "appserver"
		appserver.puppet_install.puppet_version = :latest 
		appserver.vm.provision "puppet" do |puppet|
			puppet.environment_path = "environments"
			puppet.environment = "test"
			puppet.manifests_path = "environments/test/manifests"
			puppet.manifest_file = "default.pp"
		end
	  end
	
	  config.vm.define "dbserver" do |dbserver|
		dbserver.vm.hostname = "dbserver"
		dbserver.puppet_install.puppet_version = :latest 
		dbserver.vm.provision :puppet do |puppet|
			puppet.environment_path = "environments"
			puppet.environment = "test"
			puppet.manifests_path = "environments/test/manifests"
			puppet.module_path = "environments/test/modules"
			puppet.manifest_file = "default.pp"
		end
	  end

end
