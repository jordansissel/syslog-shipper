require 'spec_helper'

describe SyslogShipper::Client do
  describe '#receive_data' do
    before(:each) do

    end

    it 'builds a message'
    it 'prints the message if in verbose mode'
    it 'sends data'
  end

  describe '#build_message' do
    context 'raw mode' do
      it 'does not modify the message'
    end

    context 'non-raw mode' do
      it 'prepends the timestamp and host'
    end
    
  end
end