require "rake"
require "rake/testtask"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "syslog_shipper"
require "benchmark"
require "tmpdir"

task :default => [:test, :spec, :cukes]

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose    = true
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
  t.verbose = true
end

Cucumber::Rake::Task.new(:cukes) do |t|
  t.cucumber_opts = %w{--format pretty}
end