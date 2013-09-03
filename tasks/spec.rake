require "rspec/core/rake_task"

desc "Run RSpec against the package's specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(-c -fs)
  t.pattern = 'spec/*_spec.rb'
end

desc "Run RSpec generate a code coverage report"
RSpec::Core::RakeTask.new(:coverage) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.rcov = true
  t.rcov_opts = %w[--rails --exclude gems,spec]
end