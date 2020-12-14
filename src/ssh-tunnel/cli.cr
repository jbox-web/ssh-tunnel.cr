module SSHTunnel
  # :nodoc:
  class CLI < Admiral::Command
    define_version SSHTunnel.version
    define_help description: "SSH Tunnel"

    define_flag config : String,
      description: "Path to config file",
      long: "config",
      short: "c",
      default: SSHTunnel::DEFAULT_CONFIG_FILE

    def run
      SSHTunnel.load_config(flags.config)
      SSHTunnel.boot_application!
    end
  end
end
