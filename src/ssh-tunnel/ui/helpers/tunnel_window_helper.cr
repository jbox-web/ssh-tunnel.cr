module SSHTunnel
  module UI
    module Helpers
      module TunnelWindowHelper
        macro included
          include SSHTunnel::UI::Helpers::Common::ModalHelper
          include SSHTunnel::UI::Helpers::Common::TranslationHelper
          include SSHTunnel::UI::Helpers::Common::FormHelper
          include SSHTunnel::UI::Helpers::Tunnel::FormHelper
        end
      end
    end
  end
end
