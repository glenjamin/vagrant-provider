require_relative "base-command"

module VagrantPlugins::Provider
  class StashCommand < BaseCommand
    def execute
      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant provider stash [machine-name]"
        o.separator ""
        o.separator "Store current provider state for later"
        o.separator ""
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv
      if argv.length > 1
        raise Vagrant::Errors::CLIInvalidUsage,
          help: opts.help.chomp
      end

      machine_name = (argv[0] || @env.primary_machine_name).to_sym

      if not machine_names.include? machine_name
        raise Vagrant::Errors::MachineNotFound,
          name: machine_name
      end

      provider = active_provider(machine_name)

      if not provider
        raise NoActiveProvider
      end

      source = machine_folder.join("#{machine_name}")
      target = machine_folder.join("#{machine_name}_#{provider[:name]}")

      if target.exist?
        raise AlreadyStashedProvider
      end

      source.rename(target)

      line "Stored #{provider[:name]} provider for later use"

      # Success, exit status 0
      0
    end
  end
end