module SSHTunnel
  # :nodoc:
  module Config
    class Tunnel
      include JSON::Serializable
      include YAML::Serializable

      @[YAML::Field(ignore: true)]
      property uuid : UUID = UUID.random
      property name : String = ""
      property type : String = ""
      property local_host : String = ""
      property local_port : Int32 = 0
      property remote_host : String = ""
      property remote_port : Int32 = 0
      property auto_start : Bool?

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property started : Bool?

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property parent : SSHTunnel::Config::Host?

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property process : Process?

      @[YAML::Field(ignore: true)]
      @[JSON::Field(ignore: true)]
      property raw : JSON::Any?

      def after_initialize
        update_raw
      end

      def []=(key, value)
        case key
        when :name
          @name = value
        when :type
          @type = value
        when :local_host
          @local_host = value
        when :local_port
          @local_port = value.to_i
        when :remote_host
          @remote_host = value
        when :remote_port
          @remote_port = value.to_i
        else
          puts "Unknown attributes: #{key}"
        end
      end

      def fetch(key)
        @raw.not_nil!.dig?(key)
      end

      def to_s
        "#{parent.to_s} - #{name}" # ameba:disable Lint/RedundantStringCoercion
      end

      def started?
        @started
      end

      def start!
        return if started?

        puts "Starting tunnel : #{to_s}"

        cmd, args = build_ssh_command

        @process = Process.new(command: cmd, args: args, output: Process::Redirect::Close, error: STDOUT, input: Process::Redirect::Pipe, shell: false)
        @started = true
      end

      def stop!
        return unless started?
        return if @process.nil?

        puts "Stopping tunnel : #{to_s}"

        if process = @process
          begin
            process.terminate
            process.wait
          rescue e : Exception
            puts e.message
          end
        end

        @process = nil
        @started = false
      end

      def build_ssh_command
        parent = @parent.not_nil!

        args = [
          "-N",
          "-t",
          "-x",
          "-o", "ExitOnForwardFailure=yes",
          "-l#{parent.user}",
          "-L#{local_host}:#{local_port}:#{remote_host}:#{remote_port}",
          "-p#{parent.port}",
        ]

        args << "-i#{parent.identity_file}" unless parent.identity_file.nil?
        args << parent.host

        {"/usr/bin/ssh", args}
      end

      private def update_raw
        @raw = JSON.parse(to_json)
      end
    end
  end
end
