# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
## Database
$DBHOST = "localhost"
$DBNAME = "mauticdb"
$DBUSER = "mauticuser"
$DBPASSWD = "mauticpwd"
### Google Cloud
$GOOGLE_PROJECT_ID = "YOUR_GOOGLE_CLOUD_PROJECT_ID"
$GOOGLE_CLIENT_EMAIL = "YOUR_SERVICE_ACCOUNT_EMAIL_ADDRESS"
$GOOGLE_JSON_KEY_LOCATION = "/path/to/your/private-key.json"
$LOCAL_USER = "Randall"
$LOCAL_SSH_KEY = "~/.ssh/id_rsa"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "debian/contrib-stretch64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.

  # Virtual-Box provisioning
  config.vm.define "virtualbox" do |vb|
    # Disable 'vagrant-vbguest' auto update
    # vb.vbguest.auto_update = false
    # Setup localhost configuration and MariaDB database
    vb.vm.provision "LocalHost-Setup", type: "shell", preserve_order: true, path: "./provisioners/localhost/localhost-setup.sh"
  end
  
  # Google provisioning
  # Reference: https://github.com/mitchellh/vagrant-google
  config.vm.provider :google do |google, override|
    override.vm.box = "google/gce"

    google.google_project_id = $GOOGLE_PROJECT_ID
    google.google_client_email = $GOOGLE_CLIENT_EMAIL
    google.google_json_key_location = $GOOGLE_JSON_KEY_LOCATION
    
    google.image_family = 'debian-9'

    google.name = "mautic-vagrant"
    google.machine_type = "n1-standard-1"
    google.zone = "us-central1-f"
    google.metadata = {'custom' => 'metadata', 'testing' => 'Hello'}
    google.tags = ['vagrantbox', 'dev']

    override.ssh.username = $LOCAL_USER
    override.ssh.private_key_path = $LOCAL_SSH_KEY
  end

  # View the documentation for the provider you are using for more
  # information on available options.
  #
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  #
  # Install Debian, PHP, and Mautic dependancies (and php.ini time-zone configuration)
  config.vm.provision "Install-Mautic-System", type: "shell", preserve_order: true, path: "install-mautic-system.sh", env: {
    "TIMEZONE" => "America\/Los_Angeles/"
  }
  # Install Database
  config.vm.provision "Database-Setup", type: "shell", preserve_order: true, path: "./provisioners/database-setup.sh", sensitive: true, env: {
  "DBHOST" => $DBHOST, 
  "DBNAME" => $DBNAME, 
  "DBUSER" => $DBUSER, 
  "DBPASSWD" => $DBPASSWD
} 
  # Install Mautic
  config.vm.provision "Install-Mautic", type: "shell", preserve_order: true, path: "install-mautic.sh"
end
