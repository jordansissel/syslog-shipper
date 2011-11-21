Gem::Specification.new do |spec|
  files = []
  files << "bin/syslog-shipper"

  rev = Time.now.strftime("%Y%m%d%H%M%S")
  spec.name = "syslog-shipper"
  spec.version = "1.0.#{rev}"
  spec.summary = "syslog-shipper - a tool for streaming logs from files to a remote syslog server"
  spec.description = "Ship logs from files to a remote syslog server over TCP"
  spec.add_dependency("eventmachine-tail")
  spec.files = files
  spec.bindir = "bin"
  spec.executables << "syslog-shipper"

  spec.author = "Jordan Sissel"
  spec.email = "jordan@loggly.com"
  spec.homepage = "https://github.com/jordansissel/syslog-shipper"
end

