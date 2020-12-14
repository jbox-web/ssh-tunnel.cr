module SSHTunnel
  module UI
    module Windows
      module Tunnels
        @[Gtk::UiTemplate(file: "resources/ui/tunnels/delete_window.ui", children: %w(label.confirm button.cancel button.submit))]
        class DeleteWindow < Gtk::Window
          include Gtk::WidgetTemplate
          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper

          @application : SSHTunnel::UI::Application
          @window : SSHTunnel::UI::Windows::Hosts::EditWindow | SSHTunnel::UI::Windows::Hosts::NewWindow
          @tunnel : SSHTunnel::Config::Tunnel
          @host : SSHTunnel::Config::Host?

          def initialize(@application, @window, @tunnel)
            # Initialize parent class
            super(application: @application, transient_for: @window)

            # Set window title
            self.title = t("window.tunnel.delete", tunnel: @tunnel.to_s)

            # Set instance variables
            @host = tunnel.parent.not_nil!

            # Set label
            set_confirm_label

            # Bind buttons listeners
            bind_submit_button
            bind_cancel_button
          end

          private def set_confirm_label
            label = Gtk::Label.cast(template_child("label.confirm"))
            label.label = t("label.confirm")
          end

          private def bind_submit_button
            button = Gtk::Button.cast(template_child("button.submit"))
            button.label = t("button.submit")

            button.clicked_signal.connect do
              @host.not_nil!.delete_tunnel(@tunnel)
              @application.config.save!
              close
              @window.reload_tunnels_treeview(@host)
            end
          end
        end
      end
    end
  end
end
