require 'openssl'

module SyslogShipper::TlsWrapper
  def post_init
    puts 'post init' if SyslogShipper::Client.verbose
    start_tls :verify_peer => SyslogShipper::Client.with_tls
  end

  def connection_completed
    puts 'connection completed' if SyslogShipper::Client.verbose
  end

  def ssl_verify_peer cert
    puts 'verifying peer' if SyslogShipper::Client.verbose
    return true if SyslogShipper::Client.bypass_peer_check || $server_handshake_completed

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
    
    puts 'verified peer' if SyslogShipper::Client.verbose
    true
  end

  def ssl_handshake_completed
    puts 'ssl handshake completed' if SyslogShipper::Client.verbose
    $server_handshake_completed = true
  end

  def unbind

  end

  private 

  def read_ca_cert
    OpenSSL::X509::Certificate.new(File.read(SyslogShipper::Client.ca_cert))
  end
end
