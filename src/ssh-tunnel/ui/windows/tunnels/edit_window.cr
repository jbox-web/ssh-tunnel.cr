module SSHTunnel
  module UI
    module Windows
      module Tunnels
        @[Gtk::UiTemplate(
          file: "resources/ui/tunnels/edit_window.ui",
          children: %w(
            button.cancel
            button.submit
            label.tunnel.name
            input.tunnel.name
            error.tunnel.name
            label.tunnel.type
            input.tunnel.type
            error.tunnel.type
            label.tunnel.local_host
            input.tunnel.local_host
            error.tunnel.local_host
            label.tunnel.local_port
            input.tunnel.local_port
            error.tunnel.local_port
            label.tunnel.remote_host
            input.tunnel.remote_host
            error.tunnel.remote_host
            label.tunnel.remote_port
            input.tunnel.remote_port
            error.tunnel.remote_port
          )
        )]
        class EditWindow < Gtk::Window
          include Gtk::WidgetTemplate
          include SSHTunnel::UI::Helpers::TunnelWindowHelper

          @application : SSHTunnel::UI::Application
          @window : SSHTunnel::UI::Windows::Hosts::EditWindow | SSHTunnel::UI::Windows::Hosts::NewWindow
          @tunnel : SSHTunnel::Config::Tunnel
          @host : SSHTunnel::Config::Host?
          @form_scope : String

          def initialize(@application, @window, @tunnel, @form_scope = "tunnel")
            # Initialize parent class
            super(application: @application, transient_for: @window)

            # Set window title
            self.title = t("window.tunnel.edit", tunnel: @tunnel.to_s)

            # Set instance variables
            @host = tunnel.parent.not_nil!

            # Bind buttons listeners
            bind_submit_button
            bind_cancel_button

            # Bind form inputs
            set_form_labels(scope: @form_scope, keys: form_fields.keys)

            # Fills input fields
            restore_form_values(scope: @form_scope, model: @tunnel)
          end
        end
      end
    end
  end
end
