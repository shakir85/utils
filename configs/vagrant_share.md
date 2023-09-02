Put this in Vagrantfile 
```
VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #....
  # Start Dynamic Shares
  if File.exists?('share.yaml')
    require 'yaml'
    yaml = YAML.load_file(Dir.pwd + '/share.yaml')
    yaml.each do |share|
      share_group = 'vagrant'
      share_group = 'apache' if share['target'] =~ /www\/html/
      config.vm.synced_folder share['source'], share['target'], create: true, owner: 'vagrant', group: share_group
    end
  end
  # End Dynamic Shares
  #...
end
```


share.yaml example
```
-
  source: '/Users/jwhitcraft/Sites'
  target: '/var/www/html/Sites'
-
  source: '/Users/jwhitcraft/Documents'
  target: '/var/www/html/Docs'
```

Source: https://h2ik.co/2014/05/14/dynamic-vagrant-shares/
