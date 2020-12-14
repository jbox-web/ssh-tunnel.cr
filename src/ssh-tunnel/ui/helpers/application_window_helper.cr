module SSHTunnel
  module UI
    module Helpers
      module ApplicationWindowHelper
        def load_hosts_treeview
          @hosts_treeview = create_treeview(SSHTunnel::UI::TreeViews::HostTreeview, all_hosts, "scrolled_window.hosts")
        end

        def reload_hosts_treeview
          @hosts_treeview.not_nil!.unmap
          load_hosts_treeview
        end

        private def bind_treeview(treeview)
          hosts_treeview_bind_single_click(treeview)
          hosts_treeview_bind_double_click(treeview)
        end

        private def hosts_treeview_bind_single_click(treeview)
          treeview.selection.changed_signal.connect do
            with_host_model do |object|
              disable_buttons_if_tunnels_running(object)
            end
          end
        end

        private def hosts_treeview_bind_double_click(treeview)
          treeview.row_activated_signal.connect do |path|
            if path.depth == 1
              with_host_model do |object|
                object.toggle_tunnels!
                reload_hosts_treeview
              end
            else
              false
            end
          end
        end

        private def disable_buttons_if_tunnels_running(host)
          if host.started?
            disable_button("button.host.edit")
            disable_button("button.host.delete")
          else
            enable_button("button.host.edit")
            enable_button("button.host.delete")
          end
        end

        private def enable_button(button)
          button = Gtk::Button.cast(template_child(button))
          button.sensitive = true
        end

        private def disable_button(button)
          button = Gtk::Button.cast(template_child(button))
          button.sensitive = false
        end
      end
    end
  end
end
