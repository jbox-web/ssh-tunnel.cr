module SSHTunnel
  module UI
    module TreeViews
      class TunnelTreeview < BaseTreeView
        def self.create_treeview_model(tunnels)
          model = Gtk::TreeStore.new(*tunnel_columns_types)

          tunnels.each do |tunnel|
            iter = model.append(nil)
            model.set(iter, tunnel_columns, tunnel_columns_data(tunnel))
          end

          model
        end

        def self.selection_column
          Columns::TUNNEL_UUID.value
        end

        enum Columns
          TUNNEL_UUID
          TUNNEL_NAME
          TUNNEL_TYPE
          TUNNEL_LOCAL_HOST
          TUNNEL_LOCAL_PORT
          TUNNEL_REMOTE_HOST
          TUNNEL_REMOTE_PORT
          TUNNEL_AUTO_START
        end

        def self.tunnel_columns
          {
            Columns::TUNNEL_UUID.value,
            Columns::TUNNEL_NAME.value,
            Columns::TUNNEL_TYPE.value,
            Columns::TUNNEL_LOCAL_HOST.value,
            Columns::TUNNEL_LOCAL_PORT.value,
            Columns::TUNNEL_REMOTE_HOST.value,
            Columns::TUNNEL_REMOTE_PORT.value,
            Columns::TUNNEL_AUTO_START.value,
          }
        end

        def self.tunnel_columns_types
          {
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
          }
        end

        def self.tunnel_columns_data(tunnel)
          {tunnel.uuid.to_s, tunnel.name, translate_tunnel_type(tunnel.type), tunnel.local_host, tunnel.local_port, tunnel.remote_host, tunnel.remote_port, tunnel.auto_start.to_s}
        end

        def self.treeview_add_columns(treeview)
          add_text_column treeview, title: t("view.tunnel.uuid"), visible: false, attributes: {text: Columns::TUNNEL_UUID.value}
          add_text_column treeview, title: t("view.tunnel.name"), visible: true, attributes: {text: Columns::TUNNEL_NAME.value}
          add_text_column treeview, title: t("view.tunnel.type"), visible: true, attributes: {text: Columns::TUNNEL_TYPE.value}
          add_text_column treeview, title: t("view.tunnel.local_host"), visible: true, attributes: {text: Columns::TUNNEL_LOCAL_HOST.value}
          add_text_column treeview, title: t("view.tunnel.local_port"), visible: true, attributes: {text: Columns::TUNNEL_LOCAL_PORT.value}
          add_text_column treeview, title: t("view.tunnel.remote_host"), visible: true, attributes: {text: Columns::TUNNEL_REMOTE_HOST.value}
          add_text_column treeview, title: t("view.tunnel.remote_port"), visible: true, attributes: {text: Columns::TUNNEL_REMOTE_PORT.value}
          add_text_column treeview, title: t("view.tunnel.auto_start"), visible: true, attributes: {text: Columns::TUNNEL_AUTO_START.value}
        end
      end
    end
  end
end
