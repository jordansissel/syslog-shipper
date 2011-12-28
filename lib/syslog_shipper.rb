require "eventmachine"
require "eventmachine-tail"
require File.expand_path('../syslog_shipper/client.rb',  __FILE__)
require File.expand_path('../syslog_shipper/tls_wrapper.rb',  __FILE__)

module SyslogShipper; end
