require 'openssl'
require 'thread'

module SyslogShipper::TlsWrapper
  class << self
    attr_accessor :verified
  end

  def initialize(ca_cert = nil, with_tls = false, bypass_peer_check = false, verbose = false)
    @ca_cert = ca_cert
    @with_tls = true
    @bypass_peer_check = bypass_peer_check
    @verbose = verbose
  end

  def post_init
    puts 'post init' if @verbose
    
    start_tls :verify_peer => @with_tls
  end

  def connection_completed
    puts 'connection completed' if @verbose
  end

  def ssl_verify_peer cert
    puts 'verifying peer' if @verbose
    unless defined?(@@verified)
      return true if @bypass_peer_check

      server_cert = OpenSSL::X509::Certificate.new cert
      verified = false

      if @ca_cert
        ca_cert = read_ca_cert
        verified = server_cert.verify(ca_cert.public_key)
      end

      unless verified
        puts server_cert.inspect
        print "The server certificate is not recognized, would you still like to connect? (Y/N) "
        answer = STDIN.gets.chomp
        unless ['y', 'yes'].include?(answer.downcase)
          raise OpenSSL::X509::CertificateError.new("Couldn't verify peer")
        end
      end
      
      @@verified = verified

      puts 'verified peer' if @verbose
    end

    true
  end

  def ssl_handshake_completed
    puts 'ssl handshake completed' if @verbose
  end

  def unbind
    puts 'connection unbound!' if @verbose
  end

  private 

  def read_ca_cert
    OpenSSL::X509::Certificate.new(File.read(@ca_cert))
  end
end
