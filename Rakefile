require 'rake'
require 'rake/clean'

Dir['tasks/**/*.rake'].each { |task| load task }

task :default => :spec

task :clean do
  %w[pkg coverage].each do |dir|
    rm_rf dir
  end
end