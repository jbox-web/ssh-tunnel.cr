module SSHTunnel
  module UI
    module Helpers
      module Tunnel
        module FormHelper
          FORM_FIELDS = {
            name: {
              type: :text,
            },
            type: {
              type:   :select,
              values: ["local", "remote"],
            },
            local_host: {
              type: :text,
            },
            local_port: {
              type: :int,
            },
            remote_host: {
              type: :text,
            },
            remote_port: {
              type: :int,
            },
          }

          private def form_fields
            FORM_FIELDS
          end

          private def form_object
            SSHTunnel::UI::Forms::TunnelForm.new(@tunnel)
          end

          private def save_and_reload_view
            @application.config.save!
            close
            @window.reload_tunnels_treeview(@host)
          end
        end
      end
    end
  end
end
