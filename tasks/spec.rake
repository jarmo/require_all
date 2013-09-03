require "rspec/core/rake_task"

desc "Run RSpec against the package's specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(-c -fs)
  t.pattern = 'spec/*_spec.rb'
end