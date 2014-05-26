require_relative "base-command"

module VagrantPlugins::Provider
  class ListCommand < BaseCommand
    def execute
      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant provider list"
        o.separator ""
        o.separator "List all active providers"
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv

      line "Machines"
      line "--------"
      line

      machine_names.each do |machine_name|
        line "#{machine_name}:"
        providers_for(machine_name).each do |provider|
          line "  #{provider[:name]}" << (provider[:active] ? " (active)" : "")
        end
      end

      # Success, exit status 0
      0
    end
  end
end