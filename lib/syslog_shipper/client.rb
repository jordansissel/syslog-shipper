require "socket"

module SyslogShipper
  class Client < EventMachine::FileTail
    class << self
      attr_accessor :ca_cert
    end

    def initialize(path, startpos=-1, connection=nil, raw=false, verbose=false)
      super(path, startpos)
      @buffer = BufferedTokenizer.new
      @hostname = Socket.gethostname
      @connection = connection
      @raw = raw
      @verbose = verbose
    end

    def receive_data(data)
      @buffer.extract(data).each do |line|
        line = if @raw
          "#{line}\n"
        else
          "#{Time.now.strftime("%b %d %H:%M:%S")} #{@hostname} #{path}: #{line}\n"
        end
   
        print line if @verbose
        send_data(line)
      end 
    end

    private

    def send_data line
      @connection.send_data line        
    end
  end
end
