module VagrantPlugins::Provider
  class BaseCommand < Vagrant.plugin('2', :command)

    def machine_names
      @env.machine_names
    end

    def providers_for(name)
      return [] unless machine_folder.directory?

      name = name.to_s

      machine_folder.children(true)
        .select(&:directory?)
        .map { |f| f.basename.to_s }
        .select { |f| f.start_with?(name) }
        .map do |f|
          {
            name: provider_name(machine_folder.join(f)),
            active: f == name
          }
        end
        .select { |f| f[:name] }
    end

    def provider_name(folder)
      folder.children(true)
        .select(&:directory?)
        .select { |f| f.join("id").file? }
        .map { |f| f.basename.to_s.to_sym }
        .first
    end

    def active_provider(machine_name)
      providers_for(machine_name).detect { |p| p[:active] }
    end

    def machine_provider(machine_name, provider)
      providers_for(machine_name).detect { |p| p[:name] == provider }
    end

    def machine_folder
      @env.local_data_path.join("machines")
    end

    def line(msg = "")
      @env.ui.info msg
    end

    class NoActiveProvider < ::Vagrant::Errors::VagrantError
      error_message "There is no currently active provider"
    end

    class HasActiveProvider < ::Vagrant::Errors::VagrantError
      error_message "Sorry, you cannot replace an active provider"
    end

    class NoStashedProvider < ::Vagrant::Errors::VagrantError
      error_message "There is no matching stashed provider"
    end

    class AlreadyStashedProvider < ::Vagrant::Errors::VagrantError
      error_message "There is already a stashed provider of this type"
    end
  end
end