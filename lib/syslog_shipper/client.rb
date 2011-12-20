require "socket"

class Client < EventMachine::FileTail
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
      if @raw
        @connection.send_data("#{line}\n")
        puts line if @verbose
      else
        timestamp = Time.now.strftime("%b %d %H:%M:%S")
        syslogline = "#{timestamp} #{@hostname} #{path}: #{line}\n"
        print syslogline if @verbose
        @connection.send_data(syslogline)
      end
    end # buffer extract
  end # def receive_data
end # class Shipper