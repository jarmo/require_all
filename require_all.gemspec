require 'rubygems'

GEMSPEC = Gem::Specification.new do |s|
  s.name = "require_all"
  s.version = "1.1.0"
  s.authors = "Tony Arcieri"
  s.email = "tony@medioh.com"
  s.date = "2009-07-18"
  s.summary = "A wonderfully simple way to load your code"
  s.platform = Gem::Platform::RUBY

  # Gem contents
  s.files = Dir.glob("{lib,spec}/**/*") + ['Rakefile', 'require_all.gemspec']

  # RubyForge info
  s.homepage = "http://github.com/tarcieri/require_all"
  s.rubyforge_project = "codeforpeople"

  # RDoc settings
  s.has_rdoc = true
  s.rdoc_options = %w(--title require_all --main README.textile --line-numbers)
  s.extra_rdoc_files = ["LICENSE", "README.textile", "CHANGES"]

  # Extensions
  s.extensions = FileList["ext/**/extconf.rb"].to_a
end
