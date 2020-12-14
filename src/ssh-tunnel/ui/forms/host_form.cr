module SSHTunnel
  module UI
    module Forms
      class HostForm < ApplicationForm
        def submit(params)
          super

          # validate fields presence
          @validator.check(:name, is(:presence?, :name, @params), I18n.t("errors.type.required"))
          @validator.check(:user, is(:presence?, :user, @params), I18n.t("errors.type.required"))
          @validator.check(:host, is(:presence?, :host, @params), I18n.t("errors.type.required"))
          @validator.check(:port, is(:presence?, :port, @params), I18n.t("errors.type.required"))

          # validate port is Integer
          @validator.check(:port, is(:number?, @params[:port]), I18n.t("errors.type.invalid"))

          # validate port inclusion
          @validator.check(:port, is(:in?, cast_to_int(@params[:port]), 1..65_535), I18n.t("errors.type.invalid"))
        end
      end
    end
  end
end
