module SSHTunnel
  module UI
    module Windows
      @[Gtk::UiTemplate(file: "resources/ui/application_window.ui", children: %w(main_box scrolled_window.hosts button.host.new button.host.edit button.host.delete))]
      class ApplicationWindow < Gtk::ApplicationWindow
        include Gtk::WidgetTemplate
        include SSHTunnel::UI::Helpers::Common::TranslationHelper
        include SSHTunnel::UI::Helpers::Common::TreeViewHelper
        include SSHTunnel::UI::Helpers::ApplicationWindowHelper

        @application : SSHTunnel::UI::Application
        @hosts_treeview : Gtk::TreeView?

        def initialize(@application)
          # The parent constructor must be called to set things up.
          super application: @application

          # Set window title
          self.title = t("application.name")

          # Set instance variables
          @hosts_treeview = nil

          # Load hosts tree
          load_hosts_treeview

          # Bind events to toolbar buttons
          bind_toolbar_buttons
        end

        private def bind_toolbar_buttons
          bind_toolbar_button_host_new
          bind_toolbar_button_host_edit
          bind_toolbar_button_host_delete
        end

        private def bind_toolbar_button_host_new
          button = Gtk::Button.cast(template_child("button.host.new"))
          button.tooltip_text = t("tooltip.host.new")
          button.clicked_signal.connect do
            with_new_host_model do |object|
              window = SSHTunnel::UI::Windows::Hosts::NewWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def bind_toolbar_button_host_edit
          button = Gtk::Button.cast(template_child("button.host.edit"))
          button.tooltip_text = t("tooltip.host.edit")
          button.clicked_signal.connect do
            with_host_model do |object|
              window = SSHTunnel::UI::Windows::Hosts::EditWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def bind_toolbar_button_host_delete
          button = Gtk::Button.cast(template_child("button.host.delete"))
          button.tooltip_text = t("tooltip.host.delete")
          button.clicked_signal.connect do
            with_host_model do |object|
              window = SSHTunnel::UI::Windows::Hosts::DeleteWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def with_new_host_model
          yield SSHTunnel::Config::Host.from_json("{}")
        end

        private def with_host_model
          object = find_host_model
          yield object if object
        end

        private def find_host_model
          uuid = SSHTunnel::UI::TreeViews::HostTreeview.find_selected(@hosts_treeview)
          return nil if uuid.nil?
          all_hosts.find { |h| h.uuid.to_s == uuid }
        end

        private def all_hosts
          @application.config.hosts.not_nil!
        end
      end
    end
  end
end
