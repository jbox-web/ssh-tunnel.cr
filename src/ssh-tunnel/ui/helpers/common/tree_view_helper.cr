module SSHTunnel
  module UI
    module Helpers
      module Common
        module TreeViewHelper
          private def create_treeview(klass, scope, target)
            treeview = klass.create_treeview(scope)
            bind_treeview(treeview)
            render_treeview(treeview, target)
            treeview
          end

          private def render_treeview(treeview, target)
            # Render treeview
            scrolled_window = Gtk::ScrolledWindow.cast(template_child(target))
            scrolled_window.child = treeview
            scrolled_window.set_policy(:automatic, :automatic)
            treeview.show
          end
        end
      end
    end
  end
end
