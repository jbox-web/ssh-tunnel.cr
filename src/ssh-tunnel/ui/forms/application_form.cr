module SSHTunnel
  module UI
    module Forms
      class ApplicationForm
        @model : SSHTunnel::Config::Host | SSHTunnel::Config::Tunnel
        @params : Hash(Symbol, String)

        def initialize(@model)
          @params = Hash(Symbol, String).new
          @validator = Check.new_validation
        end

        delegate valid?, to: @validator
        delegate errors, to: @validator

        def submit(params)
          @params = params
        end

        def save
          @params.each do |key, value|
            @model[key] = value
          end
        end

        private def cast_to_int(value)
          begin
            value.to_i
          rescue e : ArgumentError
            0
          end
        end
      end
    end
  end
end
