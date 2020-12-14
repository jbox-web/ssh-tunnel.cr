module SSHTunnel
  module UI
    module Windows
      module Hosts
        @[Gtk::UiTemplate(
          file: "resources/ui/hosts/edit_window.ui",
          children: %w(
            button.cancel
            button.submit
            scrolled_window.tunnels
            button.tunnel.new
            button.tunnel.edit
            button.tunnel.delete
            label.host.name
            input.host.name
            error.host.name
            label.host.user
            input.host.user
            error.host.user
            label.host.host
            input.host.host
            error.host.host
            label.host.port
            input.host.port
            error.host.port
            label.host.identity_file
            button.host.select_identity_file
            button.host.reset_identity_file
          )
        )]
        class EditWindow < Gtk::Window
          include Gtk::WidgetTemplate
          include SSHTunnel::UI::Helpers::HostWindowHelper

          @application : SSHTunnel::UI::Application
          @window : SSHTunnel::UI::Windows::ApplicationWindow
          @host : SSHTunnel::Config::Host
          @form_scope : String
          @tunnels_treeview : Gtk::TreeView?

          def initialize(@application, @window, @host, @form_scope = "host")
            # Initialize parent class
            super(application: @application, transient_for: @window)

            # Set window title
            self.title = t("window.host.edit", host: @host.to_s)

            # Bind buttons listeners
            bind_submit_button
            bind_cancel_button

            bind_host_buttons
            bind_tunnels_buttons

            # Bind form inputs
            set_form_labels(scope: @form_scope, keys: form_fields.keys)

            # Fills input fields
            restore_form_values(scope: @form_scope, model: @host)

            # Load tunnels treeview
            load_tunnels_treeview(@host)
          end
        end
      end
    end
  end
end
