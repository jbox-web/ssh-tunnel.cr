# Load std libs
require "json"
require "yaml"
require "uuid"
require "uuid/json"

# Load external libs
require "crystal-env/core"
require "admiral"
require "gtk4"
require "i18n"
require "validator/check"
require "validator/is"

# Set environment
Crystal::Env.default("development")

# Load ssh-tunnel
require "./ssh-tunnel/**"

class Gtk::Window
  def reload_tunnels_treeview(host)
  end
end

module SSHTunnel
  VERSION = "0.1.0"

  DEFAULT_CONFIG_FILE = "~/.config/ssh-tunnel/config.json"

  def self.version
    VERSION
  end

  def self.load_config(config_path : String)
    self.config_file = File.expand_path(config_path, home: true)
    self.config = read_config(config_file)
  end

  def self.config_file=(config_file : String)
    @@config_file = config_file
  end

  def self.config_file
    @@config_file || default_config_file
  end

  def self.config=(config : SSHTunnel::Config::Base)
    @@config = config
  end

  def self.config
    @@config ||= default_config
  end

  def self.default_config
    SSHTunnel::Config::Base.from_json("{}")
  end

  def self.default_config_file
    File.expand_path(DEFAULT_CONFIG_FILE, home: true)
  end

  def self.read_config(config_path)
    begin
      json = File.read(config_file)
    rescue
      default_config
    else
      begin
        SSHTunnel::Config::Base.from_json(json)
      rescue e : JSON::ParseException
        default_config
      end
    end
  end

  def self.setup_locales
    I18n.config.loaders << I18n::Loader::YAML.new("config/locales")
    I18n.config.default_locale = :fr
    I18n.init
  end

  def self.setup_signals(app)
    Signal::TERM.trap do
      app.quit
    end
  end

  def self.boot_application!
    # First setup locales
    setup_locales

    # Second, we need to load the resource!!
    Gio.register_resource("resources/resources.xml")

    # Then start the app
    app = SSHTunnel::UI::Application.new

    # Setup Linux signals
    # setup_signals(app)

    # Don't pass ARGC/ARGV to app.run()
    # because they will be catched by GTK which
    # doesn't know about our args.
    # See `SSHTunnel::CLI` class for more infos about
    # our args.
    exit(app.run(nil))
  end
end

# Start the CLI
unless Crystal.env.test?
  begin
    SSHTunnel::CLI.run
  rescue e : Exception
    puts e.message
    exit 1
  end
end
