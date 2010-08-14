require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/autoload_shared.rb'

describe "autoload_all" do
  it "provides require_all functionality by using 'autoload' instead of 'require'" do
    should_not be_loaded("Autoloaded::Module1::A")
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded"
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  it "doesn't autoload files with wrong module names" do
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded"
    should_not be_loaded("Autoloaded::WrongModule::WithWrongModule", "WrongModule::WithWrongModule")
  end

  before(:all) do
    @base_dir = File.dirname(__FILE__) + '/fixtures/autoloaded'
    @method = :autoload_all
    @autoload_base_dir = @base_dir
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end

describe "autoload_rel" do
  it "provides autoload_all functionality relative to the current file" do
    should_not be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
    require File.dirname(__FILE__) + '/fixtures/autoloaded_rel/modules/zero'
    should be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
  end

  before(:all) do
    @base_dir = './fixtures/autoloaded'
    @method = :autoload_rel
    @autoload_base_dir = './spec/fixtures/autoloaded'
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end