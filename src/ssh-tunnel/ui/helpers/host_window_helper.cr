module SSHTunnel
  module UI
    module Helpers
      module HostWindowHelper
        macro included
          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper
          include SSHTunnel::UI::Helpers::Common::FormHelper
          include SSHTunnel::UI::Helpers::Common::TreeViewHelper
          include SSHTunnel::UI::Helpers::Host::FormHelper
        end

        def load_tunnels_treeview(host)
          @tunnels_treeview = create_treeview(SSHTunnel::UI::TreeViews::TunnelTreeview, host.not_nil!.tunnels, "scrolled_window.tunnels")
        end

        def reload_tunnels_treeview(host)
          @tunnels_treeview.not_nil!.unmap
          load_tunnels_treeview(host)
        end

        private def bind_treeview(treeview)
          tunnels_treeview_bind_double_click(treeview)
        end

        private def tunnels_treeview_bind_double_click(treeview)
          treeview.row_activated_signal.connect do |path|
            if path.depth == 1
              with_tunnel_model do |object|
                window = SSHTunnel::UI::Windows::Tunnels::EditWindow.new(@application, self, object)
                window.present
              end
            else
              false
            end
          end
        end

        private def bind_host_buttons
          # button_reset_identity_file.label = t("button.reset")
          # button_reset_identity_file.tooltip_text = t("tooltip.host.reset_identity_file")
          # button_reset_identity_file.signal_connect :clicked do
          #   input_identity_file.unselect_all
          # end
        end

        private def bind_tunnels_buttons
          bind_tunnels_buttons_add
          bind_tunnels_buttons_edit
          bind_tunnels_buttons_delete
        end

        private def bind_tunnels_buttons_add
          button = Gtk::Button.cast(template_child("button.tunnel.new"))
          button.label = t("button.new")
          button.tooltip_text = t("tooltip.tunnel.new")

          button.clicked_signal.connect do
            with_new_tunnel_model do |object|
              window = SSHTunnel::UI::Windows::Tunnels::NewWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def bind_tunnels_buttons_edit
          button = Gtk::Button.cast(template_child("button.tunnel.edit"))
          button.label = t("button.edit")
          button.tooltip_text = t("tooltip.tunnel.edit")

          button.clicked_signal.connect do
            with_tunnel_model do |object|
              window = SSHTunnel::UI::Windows::Tunnels::EditWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def bind_tunnels_buttons_delete
          button = Gtk::Button.cast(template_child("button.tunnel.delete"))
          button.label = t("button.delete")
          button.tooltip_text = t("tooltip.tunnel.delete")

          button.clicked_signal.connect do
            with_tunnel_model do |object|
              window = SSHTunnel::UI::Windows::Tunnels::DeleteWindow.new(@application, self, object)
              window.present
            end
          end
        end

        private def with_new_tunnel_model
          yield build_object_model
        end

        private def build_object_model
          model = SSHTunnel::Config::Tunnel.from_json("{}")
          model.parent = @host
          model
        end

        private def with_tunnel_model
          object = find_tunnel_model
          yield object if object
        end

        private def find_tunnel_model
          uuid = SSHTunnel::UI::TreeViews::TunnelTreeview.find_selected(@tunnels_treeview)
          return nil if uuid.nil?
          all_tunnels.find { |t| t.uuid.to_s == uuid }
        end

        private def all_tunnels
          @host.not_nil!.tunnels
        end
      end
    end
  end
end
