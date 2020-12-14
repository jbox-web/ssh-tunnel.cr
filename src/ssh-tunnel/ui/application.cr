module SSHTunnel
  module UI
    class Application < Gtk::Application
      def initialize(**kwargs)
        super application_id: "com.jbox-web.ssh-tunnel"

        on_activate do |application|
          window = SSHTunnel::UI::Windows::ApplicationWindow.new(self)
          window.connect "destroy", &->quit
          window.show_all
        end
      end
    end
  end
end
