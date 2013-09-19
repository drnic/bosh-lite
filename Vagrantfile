Vagrant.configure('2') do |config|
  config.vm.hostname='bosh-lite'

  config.vm.provider :virtualbox do |provider, override|
    override.vm.box = 'precise64'
    override.vm.box_url = 'http://files.vagrantup.com/precise64.box'
    override.omnibus.chef_version = "10.26.0"

    provider.customize ["modifyvm", :id, "--memory", 3*1024]
    provider.customize ["modifyvm", :id, "--cpus", 4]

    override.vm.network :private_network, ip: '192.168.50.4'

    override.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks', 'site-cookbooks']

      chef.add_recipe 'bosh-lite::apt-update'
      chef.add_recipe 'build-essential::default'
      chef.add_recipe 'bosh-lite::warden'
      chef.add_recipe 'bosh-lite::bosh'
      chef.add_recipe 'bosh-lite::update-kernel'
      chef.add_recipe 'bosh-lite::reboot'
    end
  end

  config.vm.provider :vmware_fusion do |provider, override|
    override.vm.box = 'precise64'
    override.vm.box_url = 'http://files.vagrantup.com/precise64_vmware.box'

    provider.vmx["numvcpus"] = "4"
    provider.vmx["memsize"] = 3 * 1024

    override.vm.network :private_network, ip: '192.168.50.4'

    override.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks', 'site-cookbooks']

      chef.add_recipe 'bosh-lite::apt-update'
      chef.add_recipe 'build-essential::default'
      chef.add_recipe 'bosh-lite::warden'
      chef.add_recipe 'bosh-lite::bosh'
      chef.add_recipe 'bosh-lite::update-kernel'
      chef.add_recipe 'bosh-lite::reboot'
    end
  end

  config.vm.provider :aws do |provider, override|
    override.vm.box = "dummy"

    provider.access_key_id = ENV["BOSH_AWS_ACCESS_KEY_ID"]
    provider.secret_access_key = ENV["BOSH_AWS_SECRET_ACCESS_KEY"]
    provider.keypair_name = ENV["BOSH_KEYPAIR_NAME"] || "bosh"

    provider.ami = "ami-23d9a94a"  # offical Precise AMI on us-east-1
    provider.instance_type = ENV["BOSH_LITE_AWS_INSTANCE_TYPE"] || "m1.xlarge"
    provider.tags = { "Name" => "Vagrant" }
    provider.security_groups =  [ENV["BOSH_LITE_AWS_SECURITY_GROUP"] || "inception"]

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV["BOSH_LITE_PRIVATE_KEY_PATH"] || "~/.ssh/id_rsa_bosh"

    override.vm.provision :shell, :path => "scripts/aws_precise_customize.sh"

    override.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks', 'site-cookbooks']
      chef.log_level = :debug
      chef.add_recipe 'bosh-lite::provider.files'
      chef.add_recipe 'build-essential::default'
      chef.add_recipe 'bosh-lite::warden'
      chef.add_recipe 'bosh-lite::bosh'
      chef.add_recipe 'bosh-lite::bosh_cli'
      # chef.add_recipe 'bosh-lite::reboot'
    end

    override.vm.provision :shell,  :inline => "ip=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`; echo Public IP is $ip; echo Now you can bosh target $ip, or run vagrant ssh and then bosh target 127.0.0.1"
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.client_id = ENV["BOSH_DIGITAL_OCEAN_CLIENT_ID"] || ENV["DIGITAL_OCEAN_CLIENT_ID"]
    provider.api_key = ENV["BOSH_DIGITAL_OCEAN_API_KEY"] || ENV["DIGITAL_OCEAN_API_KEY"]

    override.vm.provision :shell, :path => "scripts/aws_precise_customize.sh"

    override.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks', 'site-cookbooks']
      chef.log_level = :debug
      chef.add_recipe 'bosh-lite::provider.files'
      chef.add_recipe 'build-essential::default'
      chef.add_recipe 'bosh-lite::warden'
      chef.add_recipe 'bosh-lite::bosh'
      chef.add_recipe 'bosh-lite::bosh_cli'
      # chef.add_recipe 'bosh-lite::reboot'
    end
  end

end

