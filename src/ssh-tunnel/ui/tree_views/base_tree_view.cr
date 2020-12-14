module SSHTunnel
  module UI
    module TreeViews
      class BaseTreeView
        def self.create_treeview(entries)
          treeview_model = create_treeview_model(entries)
          treeview_object = create_treeview_object(treeview_model)
          treeview_object
        end

        def self.create_treeview_object(model)
          treeview = Gtk::TreeView.new_with_model(model)
          treeview.selection.mode = :single

          # add columns to the tree view
          treeview_add_columns(treeview)

          treeview
        end

        def self.find_selected(treeview)
          treeview = treeview.not_nil!
          selected = treeview.selection.selected
          uuid = treeview.model.not_nil!.value(selected, selection_column).as_s?
          uuid
        end

        def self.add_text_column(treeview, **attributes)
          renderer = Gtk::CellRendererText.new
          add_column(treeview, renderer, **attributes)
        end

        def self.add_image_column(treeview, **attributes)
          renderer = Gtk::CellRendererPixbuf.new
          add_column(treeview, renderer, **attributes)
        end

        def self.add_column(treeview, renderer, **attributes)
          column = Gtk::TreeViewColumn.new(title: attributes[:title], visible: attributes[:visible])

          # bind column to TreeStore thanks to *text* attributes
          # See: https://docs.gtk.org/gtk3/ctor.CellRendererText.new.html
          # See: https://docs.gtk.org/gtk3/ctor.TreeViewColumn.new_with_attributes.html
          # See: https://github.com/ruby-gnome/ruby-gnome/blob/master/gtk4/lib/gtk4/tree-view-column.rb#L48
          column.pack_start(renderer, true)
          attributes[:attributes].each do |key, value|
            column.add_attribute(renderer, key.to_s, value)
          end

          treeview.append_column(column)
        end

        def self.t(*args, **kwargs)
          I18n.t(*args, **kwargs)
        end

        def self.translate_tunnel_type(type)
          t("view.tunnel.type_#{type}")
        end
      end
    end
  end
end
