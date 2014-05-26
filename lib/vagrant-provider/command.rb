require 'optparse'

module VagrantPlugins::Provider
  class Command < Vagrant.plugin('2', :command)

    def self.synopsis
      "hacky stuff for switching providers around"
    end

    def initialize(argv, env)
      super

      @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

      @subcommands = Vagrant::Registry.new

      @subcommands.register(:list) do
        require_relative "list-command"
        ListCommand
      end

      @subcommands.register(:stash) do
        require_relative "stash-command"
        StashCommand
      end

      @subcommands.register(:pick) do
        require_relative "pick-command"
        PickCommand
      end

    end

    def execute
      if @main_args.include?("-h") || @main_args.include?("--help")
        return help
      end

      # If we reached this far then we must have a subcommand. If not,
      # then we also just print the help and exit.
      command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
      return help if !command_class || !@sub_command

      # Initialize and execute the command class
      command_class.new(@sub_args, @env).execute
    end

    def help
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant provider <subcommand> [<args>]"
        opts.separator ""
        opts.separator "Available subcommands:"

        # Add the available subcommands as separators in order to print them
        # out as well.
        keys = []
        @subcommands.each { |key, value| keys << key.to_s }

        keys.sort.each do |key|
          opts.separator "    #{key}"
        end

        opts.separator ""
        opts.separator "For help on any individual subcommand run `vagrant provider <subcommand> -h`"
      end

      @env.ui.info(opts.help, prefix: false)
    end

  end
end