module SSHTunnel
  module UI
    module TreeViews
      class HostTreeview < BaseTreeView
        def self.create_treeview_model(hosts)
          model = Gtk::TreeStore.new(*host_columns_types)

          hosts.each do |host|
            iter = model.append(nil)
            model.set(iter, host_columns, host_columns_data(host))

            # add children
            host.tunnels.each do |tunnel|
              child_iter = model.append(iter)
              model.set(child_iter, tunnel_columns, tunnel_columns_data(tunnel))
            end
          end

          model
        end

        def self.selection_column
          Columns::HOST_UUID.value
        end

        enum Columns
          HOST_STATE
          HOST_UUID
          HOST_NAME
          HOST_USER
          HOST_HOST
          HOST_PORT
          TUNNEL_NAME
          TUNNEL_TYPE
          TUNNEL_LOCAL_HOST
          TUNNEL_LOCAL_PORT
          TUNNEL_REMOTE_HOST
          TUNNEL_REMOTE_PORT
          TUNNEL_AUTO_START
          TUNNEL_STARTED
        end

        def self.host_columns
          {
            Columns::HOST_STATE.value,
            Columns::HOST_UUID.value,
            Columns::HOST_NAME.value,
            Columns::HOST_USER.value,
            Columns::HOST_HOST.value,
            Columns::HOST_PORT.value,
            Columns::TUNNEL_NAME.value,
            Columns::TUNNEL_TYPE.value,
            Columns::TUNNEL_LOCAL_HOST.value,
            Columns::TUNNEL_LOCAL_PORT.value,
            Columns::TUNNEL_REMOTE_HOST.value,
            Columns::TUNNEL_REMOTE_PORT.value,
            Columns::TUNNEL_AUTO_START.value,
            Columns::TUNNEL_STARTED.value,
          }
        end

        def self.host_columns_types
          {
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
            String.g_type,
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

        def self.host_columns_data(host)
          state = host.started? ? "media-playback-start" : "media-playback-stop"
          {state, host.uuid.to_s, host.name, host.user, host.host, host.port.to_s, "", "", "", "", "", "", "", ""}
        end

        def self.tunnel_columns
          {
            Columns::TUNNEL_NAME.value,
            Columns::TUNNEL_TYPE.value,
            Columns::TUNNEL_LOCAL_HOST.value,
            Columns::TUNNEL_LOCAL_PORT.value,
            Columns::TUNNEL_REMOTE_HOST.value,
            Columns::TUNNEL_REMOTE_PORT.value,
            Columns::TUNNEL_AUTO_START.value,
            Columns::TUNNEL_STARTED.value,
          }
        end

        def self.tunnel_columns_data(tunnel)
          {tunnel.name, translate_tunnel_type(tunnel.type), tunnel.local_host, tunnel.local_port, tunnel.remote_host, tunnel.remote_port, tunnel.auto_start.to_s, tunnel.started?.to_s}
        end

        def self.treeview_add_columns(treeview)
          add_image_column treeview, title: t("view.host.state"), visible: true, attributes: {"icon-name": Columns::HOST_STATE.value}
          add_text_column treeview, title: t("view.host.uuid"), visible: false, attributes: {text: Columns::HOST_UUID.value}
          add_text_column treeview, title: t("view.host.name"), visible: true, attributes: {text: Columns::HOST_NAME.value}
          add_text_column treeview, title: t("view.host.user"), visible: true, attributes: {text: Columns::HOST_USER.value}
          add_text_column treeview, title: t("view.host.host"), visible: true, attributes: {text: Columns::HOST_HOST.value}
          add_text_column treeview, title: t("view.host.port"), visible: true, attributes: {text: Columns::HOST_PORT.value}
          add_text_column treeview, title: t("view.tunnel.name"), visible: true, attributes: {text: Columns::TUNNEL_NAME.value}
          add_text_column treeview, title: t("view.tunnel.type"), visible: true, attributes: {text: Columns::TUNNEL_TYPE.value}
          add_text_column treeview, title: t("view.tunnel.local_host"), visible: true, attributes: {text: Columns::TUNNEL_LOCAL_HOST.value}
          add_text_column treeview, title: t("view.tunnel.local_port"), visible: true, attributes: {text: Columns::TUNNEL_LOCAL_PORT.value}
          add_text_column treeview, title: t("view.tunnel.remote_host"), visible: true, attributes: {text: Columns::TUNNEL_REMOTE_HOST.value}
          add_text_column treeview, title: t("view.tunnel.remote_port"), visible: true, attributes: {text: Columns::TUNNEL_REMOTE_PORT.value}
          add_text_column treeview, title: t("view.tunnel.auto_start"), visible: true, attributes: {text: Columns::TUNNEL_AUTO_START.value}
          add_text_column treeview, title: t("view.tunnel.started"), visible: true, attributes: {text: Columns::TUNNEL_STARTED.value}
        end
      end
    end
  end
end
