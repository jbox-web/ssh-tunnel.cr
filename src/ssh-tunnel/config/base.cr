module SSHTunnel
  # :nodoc:
  module Config
    class Base
      include JSON::Serializable
      include YAML::Serializable

      property hosts : Array(SSHTunnel::Config::Host) = [] of SSHTunnel::Config::Host

      def add_host(host : SSHTunnel::Config::Host)
        @hosts << host
      end

      def delete_host(host : SSHTunnel::Config::Host)
        @hosts.delete(host)
      end

      def save!
        File.write(SSHTunnel.config_file, to_pretty_json)
      end
    end
  end
end
