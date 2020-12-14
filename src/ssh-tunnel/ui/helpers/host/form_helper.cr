module SSHTunnel
  module UI
    module Helpers
      module Host
        module FormHelper
          FORM_FIELDS = {
            name: {
              type: :text,
            },
            user: {
              type: :text,
            },
            host: {
              type: :text,
            },
            port: {
              type: :int,
            },
          }

          private def form_fields
            FORM_FIELDS
          end

          private def form_object
            SSHTunnel::UI::Forms::HostForm.new(@host)
          end

          private def save_and_reload_view
            @application.config.save!
            close
            @window.reload_hosts_treeview
          end
        end
      end
    end
  end
end
