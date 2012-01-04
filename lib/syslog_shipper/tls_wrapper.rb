require 'openssl'

module SyslogShipper::TlsWrapper
  def post_init
    start_tls :verify_peer => SyslogShipper::Client.with_tls
  end

  def connection_completed
    puts 'connection completed' if SyslogShipper::Client.verbose
  end

  def ssl_verify_peer cert
    return if SyslogShipper::Client.bypass_peer_check

    ca_cert = OpenSSL::X509::Certificate.new File.read(SyslogShipper::Client.ca_cert)
    server_cert = OpenSSL::X509::Certificate.new cert
    raise OpenSSL::X509::CertificateError("Couldn't verify peer") unless server_cert.verify(ca_cert.public_key)

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
