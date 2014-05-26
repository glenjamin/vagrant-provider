require_relative "base-command"

module VagrantPlugins::Provider
  class PickCommand < BaseCommand
    def execute
      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant provider pick <provider> [machine-name]"
        o.separator ""
        o.separator "Bring back previously stored provider state"
        o.separator ""
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv
      if argv.empty? or argv.length > 2
        raise Vagrant::Errors::CLIInvalidUsage,
          help: opts.help.chomp
      end

      provider_name = argv[0].to_sym
      machine_name = (argv[1] || @env.primary_machine_name).to_sym

      if not machine_names.include? machine_name
        raise Vagrant::Errors::MachineNotFound,
          name: machine_name
      end

      if active_provider(machine_name)
        raise HasActiveProvider
      end

      provider = machine_provider(machine_name, provider_name)
      if not provider
        raise NoStashedProvider
      end

      source = machine_folder.join("#{machine_name}_#{provider_name}")
      target = machine_folder.join("#{machine_name}")

      target.rmtree if target.exist?
      source.rename(target)

      line "Restored #{provider[:name]} provider from stash"

      # Success, exit status 0
      0
    end
  end
end