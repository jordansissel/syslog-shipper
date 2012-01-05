require 'spec_helper'

class MyTlsModule
  include SyslogShipper::TlsWrapper
end

describe SyslogShipper::TlsWrapper do

  let(:subject) {MyTlsModule.new}
  let(:server_cert) {double}
  let(:ca_cert) {double}


  before(:each) do
    subject.stub(:read_ca_cert).and_return(ca_cert)
    ca_cert.stub(:public_key)
    server_cert.stub(:public_key)
    OpenSSL::X509::Certificate.stub(:new).and_return(server_cert)

    # reset the class values
    SyslogShipper::Client.bypass_peer_check = nil 
    SyslogShipper::Client.ca_cert = nil
  end

  describe "#ssl_verify_peer" do
    context 'using a valid CA certificate' do
      before(:each) do
        SyslogShipper::Client.ca_cert = ""
        server_cert.stub(:verify).and_return true
      end

      it 'verifies the peer' do
        subject.ssl_verify_peer("").should be_true
      end
    end

    context 'connecting to an unverified peer' do
      before(:each) do
        server_cert.stub(:verify).and_return false
      end

      it 'should connect if the bypass peer checking flag is set' do
        SyslogShipper::Client.bypass_peer_check = true
        subject.ssl_verify_peer("").should be_true
      end

      it 'should connect if the user answers yes to the command prompt' do
        STDIN.stub(:gets).and_return("yes")
        subject.ssl_verify_peer("").should be_true
      end

      it 'should not connect to an untrusted peer' do
        STDIN.stub(:gets).and_return("no")
        lambda {
          subject.ssl_verify_peer("")
        }.should raise_error(OpenSSL::X509::CertificateError)
      end      
    end
  end
end