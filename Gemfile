source 'https://rubygems.org'
source "http://gems.hashicorp.com"

# see https://github.com/scalefactory/vagrant-cucumber/blob/master/Gemfile

require 'fileutils'

embedded_locations = %w{/Applications/Vagrant/embedded /opt/vagrant/embedded}

embedded_locations.each do |p|
  ENV["VAGRANT_INSTALLER_EMBEDDED_DIR"] = p if File.directory?(p)
end

unless ENV.has_key?('VAGRANT_INSTALLER_EMBEDDED_DIR')
  $stderr.puts "Couldn't find a packaged install of vagrant, and we need this"
  $stderr.puts "in order to make use of the RubyEncoder libraries."
  $stderr.puts "I looked in:"
  embedded_locations.each do |p|
    $stderr.puts " #{p}"
  end
end

group :development do
  gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git"

  # Jump through annoying hoops so we can use this plugin in the
  # bundler environment.

  fusion_path = Gem::Specification.find_by_name('vagrant-vmware-fusion').gem_dir

  unless File.symlink?( File.join( fusion_path, 'rgloader' ) )
    $stderr.puts "Linking local 'rgloader' file to embedded installer"
    FileUtils.ln_s(
      File.join( ENV["VAGRANT_INSTALLER_EMBEDDED_DIR"], 'rgloader' ),
      File.join( fusion_path, 'rgloader' )
    )
  end

  unless File.symlink?( File.join( fusion_path, 'license-vagrant-vmware-fusion.lic' ) )
    $stderr.puts "Linking your license file for vmware plugin"
    FileUtils.ln_s(
      File.join( ENV["HOME"], '.vagrant.d', 'license-vagrant-vmware-fusion.lic' ),
      File.join( fusion_path, 'license-vagrant-vmware-fusion.lic' )
    )
  end
end

group :plugins do
  gem "vagrant-vmware-fusion"
  gem "vagrant-provider", path: "."
end

# Specify your gem's dependencies in vagrant-provider.gemspec
gemspec
