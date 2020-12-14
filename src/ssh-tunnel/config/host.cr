module SSHTunnel
  # :nodoc:
  module Config
    class Host
      include JSON::Serializable
      include YAML::Serializable

      @[YAML::Field(ignore: true)]
      property uuid : UUID = UUID.random
      property name : String = ""
      property user : String = ""
      property host : String = ""
      property port : Int32 = 22
      property identity_file : String?
      property tunnels : Array(SSHTunnel::Config::Tunnel) = [] of SSHTunnel::Config::Tunnel

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property started : Bool?

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property raw : JSON::Any?

      def after_initialize
        update_raw
        tunnels.each do |t|
          t.parent = self
        end
      end

      def []=(key, value)
        case key
        when :name
          @name = value
        when :user
          @user = value
        when :host
          @host = value
        when :port
          @port = value.to_i
        else
          puts "Unknown attributes: #{key}"
        end
        update_raw
      end

      def fetch(key)
        @raw.not_nil!.dig?(key)
      end

      def to_s
        name
      end

      def add_tunnel(tunnel : SSHTunnel::Config::Tunnel)
        @tunnels << tunnel
      end

      def delete_tunnel(tunnel : SSHTunnel::Config::Tunnel)
        @tunnels.delete(tunnel)
      end

      def auto_start!
        started = tunnels.map(&.auto_start!)
        @started = started.any? # ameba:disable Performance/AnyInsteadOfEmpty
      end

      def started?
        @started
      end

      def start_tunnels!
        puts "Starting host : #{to_s}"
        tunnels.each(&.start!)
        @started = true
      end

      def stop_tunnels!
        puts "Stopping host : #{to_s}"
        tunnels.each(&.stop!)
        @started = false
      end

      def toggle_tunnels!
        if started?
          stop_tunnels!
        else
          start_tunnels!
        end
      end

      private def update_raw
        @raw = JSON.parse(to_json)
      end
    end
  end
end
