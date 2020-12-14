module SSHTunnel
  module UI
    module Helpers
      module Common
        module ModalHelper
          private def bind_cancel_button
            button = Gtk::Button.cast(template_child("button.cancel"))
            button.label = t("button.cancel")

            button.clicked_signal.connect do
              close
            end

            # Bind escape key stroke
            # key_press_signal.connect do |_widget, event|
            #   event.keyval == 65_307 ? close : false
            # end
          end
        end
      end
    end
  end
end
