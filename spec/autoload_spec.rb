require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/autoload_shared.rb'

describe "autoload_all" do

  subject { self }

  it "provides require_all functionality by using 'autoload' instead of 'require'" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_all fixture_path('autoloaded')
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  it "doesn't autoload files with wrong module names" do
    autoload_all fixture_path('autoloaded')
    is_expected.not_to be_loaded("Autoloaded::WrongModule::WithWrongModule", "WrongModule::WithWrongModule")
  end

  it "autoloads class nested into another class" do
    is_expected.not_to be_loaded("Autoloaded::Class1", "Autoloaded::Class1::C")
    autoload_all fixture_path('autoloaded')
    is_expected.to be_loaded("Autoloaded::Class1")
    expect(Autoloaded::Class1).to be_a Class
    is_expected.to be_loaded("Autoloaded::Class1::C")
  end

  it "needs to specify base_dir for autoloading if loading something from under top-level module directory" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_all fixture_path('autoloaded/module1')
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")

    autoload_all fixture_path('autoloaded/module1'), base_dir: fixture_path('autoloaded')
    is_expected.to be_loaded("Autoloaded::Module1::A")
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  before(:all) do
    @base_dir = fixture_path('autoloaded')
    @method = :autoload_all
    @autoload_base_dir = @base_dir
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end

describe "autoload_rel" do

  subject { self }

  it "provides autoload_all functionality relative to the current file" do
    is_expected.not_to be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
    require fixture_path('autoloaded_rel/modules/zero')
    is_expected.to be_loaded("Modules::Module1::First", "Modules::Module2::Second", "Modules::Zero")
  end

  it "needs to specify base_dir for autoloading if loading something from under top-level module directory" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
    autoload_rel relative_fixture_path('autoloaded/module1')
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")

    autoload_rel relative_fixture_path('autoloaded/module1'), base_dir: fixture_path('autoloaded')
    is_expected.to be_loaded("Autoloaded::Module1::A")
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName", "Autoloaded::Module2::Module3::B")
  end

  before(:all) do
    @base_dir = relative_fixture_path('autoloaded')
    @method = :autoload_rel
    @autoload_base_dir = fixture_path('autoloaded')
  end
  it_should_behave_like "#autoload_all syntactic sugar"
end
