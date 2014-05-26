require "vagrant"

module VagrantPlugins
  module Provider
    class Plugin < Vagrant.plugin("2")
      name "Provider"

      command :provider do
        require_relative "vagrant-provider/command"
        Command
      end
    end
  end
end