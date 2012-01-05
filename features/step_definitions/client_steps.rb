Given /^I have a valid endpoint$/ do
  @port = 12345
  @host_name = 'localhost'
end

Given /^I have a valid TLS endpoint$/ do
  @port = 12345
  @host_name = 'localhost'
  SyslogShipper::Client.with_tls = true
  SyslogShipper::Client.ca_cert = File.expand_path(File.dirname(__FILE__) + '../../../test_certs/ca.crt')
end

Given /^I have an invalid TLS endpoint$/ do
  SyslogShipper::Client.with_tls = true
  @port = 12345
  @host_name = 'localhost'
end

When /^I connect to that endpoint$/ do
  steps %Q{
    When I run `syslog-shipper --p -s #{@host_name}:#{@port} /Users/neilmatatall/dev/syslog-shipper/log` interactively
  }
end

When /^I securely connect to that endpoint$/ do
  file_path = File.expand_path(File.dirname(__FILE__) + '../../../test_certs/ca.crt')
  steps %Q{
    When I run `syslog-shipper --p --ca-cert #{file_path} -s #{@host_name}:#{@port} /Users/neilmatatall/dev/syslog-shipper/log` interactively
  }
end

When /^I connect to the insecure endpoint$/ do
  file_path = File.expand_path(File.dirname(__FILE__) + '../../../test_certs/ca.crt')
  steps %Q{
    When I run `syslog-shipper --p --tls -s #{@host_name}:#{@port} /Users/neilmatatall/dev/syslog-shipper/log` interactively
  }
end

When /^I connect to that endpoint with and bypass peer checking$/ do
  steps %Q{
    When I run `syslog-shipper --p --skip-peer-check -s #{@host_name}:#{@port} /Users/neilmatatall/dev/syslog-shipper/log` interactively
  }
end

When /^I am prompted to accept the certificate$/ do
  steps %Q{
    Then the output should contain "accept certificate"  
  }
end

Then /^the connection should fail$/ do
  steps %Q{
    Then the output should contain "connection failed"  
  }
end


Then /^the connection should succeed$/ do
  steps %Q{
    Then the output should contain "connection successful"  
  }
end


Then /^I am not prompted to accept the certificate$/ do
  steps %Q{
    Then the output should not contain "accept certificate"  
  }
end