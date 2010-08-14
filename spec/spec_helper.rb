require File.dirname(__FILE__) + '/../lib/require_all.rb'

module SpecHelper
  def unload_all
    %w{A B C D WrongModule Autoloaded Modules
       RelativeA RelativeB RelativeC RelativeD}.each do |const|
      Object.send(:remove_const, const) rescue nil
    end
    $LOADED_FEATURES.delete_if {|f| f =~ /autoloaded|relative|resolvable/}
  end

  def loaded?(*klazzes)
    klazzes.all? {|klazz| Object.class_eval(klazz) rescue nil}
  end
end

Spec::Runner.configure do |config|
  config.include(SpecHelper)

  config.before(:each) do
    unload_all
  end
end

module Spec
  class ExampleGroup
    subject {self}
  end
end