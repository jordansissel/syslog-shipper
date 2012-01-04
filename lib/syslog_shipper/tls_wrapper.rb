require 'openssl'

module SyslogShipper::TlsWrapper
  def post_init
    start_tls :verify_peer => SyslogShipper::Client.with_tls
  end

  def connection_completed
    puts 'connection completed' if SyslogShipper::Client.verbose
  end

  def ssl_verify_peer cert
    return true if SyslogShipper::Client.bypass_peer_check

    ca_cert = OpenSSL::X509::Certificate.new(File.read(SyslogShipper::Client.ca_cert))
    server_cert = OpenSSL::X509::Certificate.new cert
    

    unless server_cert.verify(ca_cert.public_key)
      puts "The server certificate is not recognized, would you still like to connect?"
      answer = STDIN.gets.chomp
      unless answer =~ /y|yes/i
        raise OpenSSL::X509::CertificateError.new("Couldn't verify peer")
      end
    end
    
    puts 'verified peer' if SyslogShipper::Client.verbose
    true
  end

  def ssl_handshake_completed
    puts 'ssl handshake completed' if SyslogShipper::Client.verbose
    $server_handshake_completed = true
  end

  def unbind

  end
end
