module SSHTunnel
  module UI
    module Forms
      class TunnelForm < ApplicationForm
        def submit(params)
          super

          # validate fields presence
          @validator.check(:name, is(:presence?, :name, @params), I18n.t("errors.type.required"))
          @validator.check(:type, is(:presence?, :type, @params), I18n.t("errors.type.required"))
          @validator.check(:local_host, is(:presence?, :local_host, @params), I18n.t("errors.type.required"))
          @validator.check(:local_port, is(:presence?, :local_port, @params), I18n.t("errors.type.required"))
          @validator.check(:remote_host, is(:presence?, :remote_host, @params), I18n.t("errors.type.required"))
          @validator.check(:remote_port, is(:presence?, :remote_port, @params), I18n.t("errors.type.required"))

          # validate tunnel type inclusion
          @validator.check(:type, is(:in?, @params[:type], ["remote", "local"]), I18n.t("errors.type.required"))

          # validate local_port/remote_port are Integer
          @validator.check(:local_port, is(:number?, @params[:local_port]), I18n.t("errors.type.invalid"))
          @validator.check(:remote_port, is(:number?, @params[:remote_port]), I18n.t("errors.type.invalid"))

          # validate local_port/remote_port inclusion
          @validator.check(:local_port, is(:in?, cast_to_int(@params[:local_port]), 1..65_535), I18n.t("errors.type.invalid"))
          @validator.check(:remote_port, is(:in?, cast_to_int(@params[:remote_port]), 1..65_535), I18n.t("errors.type.invalid"))
        end
      end
    end
  end
end
