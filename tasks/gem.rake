require 'rubygems/package_task'

Gem::PackageTask.new(GEMSPEC) do |pkg|
  pkg.need_tar = true
end