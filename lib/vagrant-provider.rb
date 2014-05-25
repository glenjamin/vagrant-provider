require "vagrant"

module VagrantPlugins
  module Provider
    class Plugin < Vagrant.plugin("2")
      name "Provider"
    end
  end
end