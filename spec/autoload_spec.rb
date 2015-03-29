require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/autoload_shared.rb'

describe "autoload_all" do

  subject { self }
  
  it "provides require_all functionality by using 'autoload' instead of 'require'" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded"
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  it "doesn't autoload files with wrong module names" do
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded"
    is_expected.not_to be_loaded("Autoloaded::WrongModule::WithWrongModule", "WrongModule::WithWrongModule")
  end

  it "needs to specify base_dir for autoloading if loading something from under top-level module directory" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded/module1"
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")

    autoload_all File.dirname(__FILE__) + "/fixtures/autoloaded/module1",
                 :base_dir => File.dirname(__FILE__) + "/fixtures/autoloaded"
    is_expected.to be_loaded("Autoloaded::Module1::A")
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  before(:all) do
    @base_dir = File.dirname(__FILE__) + '/fixtures/autoloaded'
    @method = :autoload_all
    @autoload_base_dir = @base_dir
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end

describe "autoload_rel" do

  subject { self }

  it "provides autoload_all functionality relative to the current file" do
    is_expected.not_to be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
    require File.dirname(__FILE__) + '/fixtures/autoloaded_rel/modules/zero'
    is_expected.to be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
  end

  it "needs to specify base_dir for autoloading if loading something from under top-level module directory" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_rel "./fixtures/autoloaded/module1"
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")

    autoload_rel "./fixtures/autoloaded/module1",
                 :base_dir => File.dirname(__FILE__) + "/fixtures/autoloaded"
    is_expected.to be_loaded("Autoloaded::Module1::A")
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  before(:all) do
    @base_dir = './fixtures/autoloaded'
    @method = :autoload_rel
    @autoload_base_dir = File.dirname(__FILE__) + "/fixtures/autoloaded"
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end
