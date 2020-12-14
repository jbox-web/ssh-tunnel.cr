require "gobject/gtk"
require "gobject/gio"

# Load stacker
require "./ssh-tunnel/**"

module SSHTunnel
  VERSION = "0.1.0"

  @@resources_path : Path | Nil
  @@resources_bin : Path | Nil
  @@resources_xml : Path | Nil

  ROOT_PATH = Path.new File.expand_path("..", __DIR__)

  def self.root_path
    ROOT_PATH
  end

  def self.resources_path
    @@resources_path ||= root_path.join("resources")
  end

  def self.resources_xml
    @@resources_xml ||= resources_path.join("gresources.xml")
  end

  def self.resources_bin
    @@resources_bin ||= Path.new(Dir.tempdir).join("gresources.bin")
  end

  def self.run
    compile_resources!
    load_resources!

    application = SSHTunnel::UI::Application.new
    application.run
  end

  def self.compile_resources!
    args = [
      "--target", resources_bin.to_s,
      "--sourcedir", resources_path.to_s,
      resources_xml.to_s,
    ]
    system("glib-compile-resources", args)
  end

  def self.load_resources!
    resources = Gio::Resource.load(resources_bin.to_s)
    resources.register
  end
end

SSHTunnel.run
