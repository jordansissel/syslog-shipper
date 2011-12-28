require 'openssl'

module SyslogShipper::TlsWrapper
  def post_init
    start_tls(:verify_peer => true)
  end

  def connection_completed

  end

  def ssl_verify_peer cert
    ca_cert = OpenSSL::X509::Certificate.new File.read(SyslogShipper::Client.ca_cert)
    server_cert = OpenSSL::X509::Certificate.new cert
    raise "Couldn't verify peer" unless server_cert.verify ca_cert.public_key
  end

  def ssl_handshake_completed
    $server_handshake_completed = true
  end

  def unbind

  end
end
