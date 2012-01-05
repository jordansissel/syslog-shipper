require "socket"

module SyslogShipper
  class Client < EventMachine::FileTail
    class << self
      attr_accessor :ca_cert
      attr_accessor :with_tls
      attr_accessor :bypass_peer_check
      attr_accessor :verbose
      attr_accessor :raw
      attr_accessor :ping
    end

    def initialize path, startpos=-1, connection=nil
      super path, startpos
      @buffer = BufferedTokenizer.new
      @hostname = Socket.gethostname
      @connection = connection
    end

    def receive_data(data)
      @buffer.extract(data).each do |line|
        if SyslogShipper::Client.ping
          puts 'connection successful'
          exit
        end
        
        if message = build_message(line)
          puts message if SyslogShipper::Client.verbose
          send_data message
        end
      end 
    end

    private

    def send_data line
      @connection.send_data line        
    end

    def build_message line
      return if line && line.gsub(/\s/, '').empty?

      if SyslogShipper::Client.raw
        "#{line}\n"
      else
        "#{Time.now.strftime("%b %d %H:%M:%S")} #{@hostname} #{path}: #{line}\n"
      end
    end
  end
end
