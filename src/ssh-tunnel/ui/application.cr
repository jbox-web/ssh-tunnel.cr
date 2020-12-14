module SSHTunnel
  module UI
    class Application < Gtk::Application
      getter config : SSHTunnel::Config::Base

      def initialize(**kwargs)
        super application_id: "com.jbox-web.ssh-tunnel", flags: Gio::ApplicationFlags::None

        @config = SSHTunnel.config

        startup_signal.connect do
          action = Gio::SimpleAction.new("quit", nil)
          action.activate_signal.connect do |_args|
            self.quit
          end
          self.add_action(action)
          self.set_accels_for_action("app.quit", ["<Ctrl>Q"])
        end

        activate_signal.connect do
          window = SSHTunnel::UI::Windows::ApplicationWindow.new(self)
          window.destroy_signal.connect do
            self.quit
          end
          window.present
        end
      end

      def quit
        puts "Quitting SSHTunnel"
        @config.hosts.not_nil!.map(&.stop_tunnels!)
        super
      end
    end
  end
end
