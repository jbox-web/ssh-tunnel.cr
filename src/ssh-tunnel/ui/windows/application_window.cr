module SSHTunnel
  module UI
    module Windows
      class ApplicationWindow < Gtk::ApplicationWindow
        self.template_from_resource = "/com/jbox-web/ssh-tunnel/ui/application_window.glade"

        def initialize(application : Gtk::Application)
          super(application: application, title: "SSH Tunnel Manager")

          init_template

          # Set instance variables
          @application = application
        end
      end
    end
  end
end
