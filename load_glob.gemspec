require 'rubygems'

GEMSPEC = Gem::Specification.new do |s|
  s.name = "load_glob"
  s.version = "1.0.1"
  s.authors = "Tony Arcieri"
  s.email = "tony@medioh.com"
  s.date = "2009-06-08"
  s.summary = "Load all files matching a given glob, resolving dependencies automagically"
  s.platform = Gem::Platform::RUBY

  # Gem contents
  s.files = Dir.glob("{lib,spec}/**/*") + ['Rakefile', 'load_glob.gemspec']

  # RubyForge info
  s.homepage = "http://github.com/tarcieri/load_glob"
  s.rubyforge_project = "codeforpeople"

  # RDoc settings
  s.has_rdoc = true
  s.rdoc_options = %w(--title load_glob --main README.textile --line-numbers)
  s.extra_rdoc_files = ["LICENSE", "README.textile", "CHANGES"]

  # Extensions
  s.extensions = FileList["ext/**/extconf.rb"].to_a
end
