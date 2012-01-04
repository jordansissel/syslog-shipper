require 'spec_helper'

class MyTlsModule
  include SyslogShipper::TlsWrapper
end

describe SyslogShipper::TlsWrapper do

  let(:subject) {MyTlsModule.new}

  describe "#ssl_verify_peer" do
    let(:cert) {double}

    before(:each) do
      SyslogShipper::Client.bypass_peer_check = false # reset the class value
      File.stub(:read)


      cert.stub(:public_key)
      OpenSSL::X509::Certificate.stub(:new).and_return(cert)
    end

    context 'using a valid CA certificate' do
      before(:each) do
        cert.stub(:verify).and_return true
      end

      it 'verifies the peer' do
        subject.ssl_verify_peer("").should be_true
      end
    end

    context 'connecting to an unverified peer' do
      before(:each) do
        cert.stub(:verify).and_return false
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