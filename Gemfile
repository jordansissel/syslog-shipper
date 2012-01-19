source :rubygems

gem "jruby-openssl", :platform => :jruby
gem "eventmachine-tail"
gem "trollop"

group :development, :test do
  gem 'rake'
  gem 'guard'
  gem 'guard-test'
  gem 'guard-rspec'
  gem 'rspec'
  gem 'guard-cucumber'
  gem 'cucumber'
  gem 'aruba'
  gem 'eventmachine'
  gem 'eventmachine-tail'
  
  require 'rbconfig'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.4.0'
    gem 'growl',      '~> 1.0.3'
  end
  if RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.8.4'
    gem 'libnotify',  '~> 0.3.0'
  end
end
