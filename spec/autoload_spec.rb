require File.dirname(__FILE__) + '/spec_helper.rb'

describe "autoload_all" do
  it "provides require_all functionality by using 'autoload' instead of 'require'" do
    defined?(Autoloaded::Module1::A).should == nil
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded"
    defined?(Autoloaded::Module1::A).should == 'constant'
    defined?(Autoloaded::Module2::LongerName).should == 'constant'
    defined?(Autoloaded::Module2::Module3::B).should == 'constant'

    defined?(Autoloaded::WrongModule::WithWrongModule).should == nil
    defined?(WrongModule::WithWrongModule).should == nil
  end
end

describe "autoload_rel" do
  it "provides autoload_all functionality relative to the current file" do
    defined?(Modules::Module1::First).should == nil
    defined?(Modules::Module2::Second).should == nil
    defined?(Modules::Zero).should == nil
    require File.dirname(__FILE__) + '/fixtures/autoloaded_rel/modules/zero'
    defined?(Modules::Module1::First).should == 'constant'
    defined?(Modules::Module2::Second).should == 'constant'
    defined?(Modules::Zero).should == 'constant'
  end
end