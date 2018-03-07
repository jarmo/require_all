require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start

require File.dirname(__FILE__) + '/../lib/require_all.rb'

module SpecHelper
  def fixture_path(fixture_name, relative_dir = File.dirname(__FILE__))
    File.join(relative_dir, 'fixtures', fixture_name)
  end

  def relative_fixture_path(fixture_name)
    fixture_path(fixture_name, '.')
  end

  def unload_all
    %w{A B C D WrongModule Autoloaded Modules
       RelativeA RelativeB RelativeC RelativeD}.each do |const|
      Object.send(:remove_const, const) rescue nil
    end
    $LOADED_FEATURES.delete_if {|f| f =~ /autoloaded|error|relative|resolvable/}
  end

  def loaded?(*klazzes)
    klazzes.all? {|klazz| Object.class_eval(klazz) rescue nil}
  end
end

RSpec.configure do |config|
  config.include SpecHelper
  config.color = true

  config.before do
    unload_all
  end
end
