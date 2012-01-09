Gem::Specification.new do |spec|
  spec.files       = %w( README LICENSE )
  spec.files       += Dir.glob("lib/**/*")
  spec.files       += Dir.glob("bin/**/*")
  spec.files       += Dir.glob("test/**/*")
  spec.files       += Dir.glob("spec/**/*")
  spec.bindir = "bin"
  spec.executables = %w{syslog-shipper}

  rev = Time.now.strftime("%Y%m%d%H%M%S")
  spec.name = "syslog-shipper"
  spec.version = "1.0.#{rev}"
  spec.summary = "syslog-shipper - a tool for streaming logs from files to a remote syslog server"
  spec.description = "Ship logs from files to a remote syslog server over TCP"
  
  spec.author = "Jordan Sissel"
  spec.email = "jordan@loggly.com"
  spec.homepage = "https://github.com/jordansissel/syslog-shipper"
  spec.add_dependency "eventmachine-tail"
  spec.add_dependency "trollop"
end

