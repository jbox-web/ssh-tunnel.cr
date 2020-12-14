module SSHTunnel
  module UI
    module Windows
      module Hosts
        @[Gtk::UiTemplate(file: "resources/ui/hosts/delete_window.ui", children: %w(label.confirm button.cancel button.submit))]
        class DeleteWindow < Gtk::Window
          include Gtk::WidgetTemplate
          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper

          @application : SSHTunnel::UI::Application
          @window : SSHTunnel::UI::Windows::ApplicationWindow
          @host : SSHTunnel::Config::Host

          def initialize(@application, @window, @host)
            # Initialize parent class
            super(application: @application, transient_for: @window)

            # Set window title
            self.title = t("window.host.delete", host: @host.to_s)

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
              @application.config.delete_host(@host)
              @application.config.save!
              close
              @window.reload_hosts_treeview
            end
          end
        end
      end
    end
  end
end
