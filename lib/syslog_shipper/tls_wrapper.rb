require 'openssl'
require 'thread'

module SyslogShipper::TlsWrapper
  class << self
    attr_accessor :verified
  end

  def post_init
    puts 'post init'
    @@semaphore ||= Mutex.new
    start_tls :verify_peer => SyslogShipper::Client.with_tls
  end

  def connection_completed
    puts 'connection completed'
  end

  def ssl_verify_peer cert
    puts 'verifying peer' 
    @@semaphore.synchronize do
      unless defined?(@@verified)
        return true if SyslogShipper::Client.bypass_peer_check

        server_cert = OpenSSL::X509::Certificate.new cert
        verified = false

        if SyslogShipper::Client.ca_cert
          ca_cert = read_ca_cert
          verified = server_cert.verify(ca_cert.public_key)
        end

        unless verified
          puts server_cert.inspect
          print "The server certificate is not recognized, would you still like to connect? (Y/N) "
          answer = STDIN.gets.chomp
          unless answer =~ /y|yes/i
            raise OpenSSL::X509::CertificateError.new("Couldn't verify peer")
          end
        end
        
        @@verified = verified

        puts 'verified peer' if SyslogShipper::Client.verbose
      end
    end

    true
  end

  def ssl_handshake_completed
    puts 'ssl handshake completed' if SyslogShipper::Client.verbose
  end

  def unbind
    exit(1)
    puts 'connection unbound!'
  end

  private 

  def read_ca_cert
    OpenSSL::X509::Certificate.new(File.read(SyslogShipper::Client.ca_cert))
  end
end
