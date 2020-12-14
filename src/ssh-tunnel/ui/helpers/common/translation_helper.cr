module SSHTunnel
  module UI
    module Helpers
      module Common
        module TranslationHelper
          def t(*args, **kwargs)
            I18n.t(*args, **kwargs)
          end
        end
      end
    end
  end
end
