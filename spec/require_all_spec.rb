require File.dirname(__FILE__) + '/spec_helper.rb'

shared_examples_for "#require_all syntactic sugar" do
  subject {self}

  before :each do
    @base_dir = File.dirname(__FILE__) + '/fixtures/autoloaded'
    @file_list = [
            "#{@base_dir}/module1/a.rb",
            "#{@base_dir}/module2/longer_name.rb",
            "#{@base_dir}/module2/module3/b.rb"
    ]
  end

  it "accepts files with and without extensions" do
    should_not be_loaded("WrongModule::WithWrongModule")
    send(@method, @base_dir + '/with_wrong_module').should be_true
    should be_loaded("WrongModule::WithWrongModule")

    should_not be_loaded("Autoloaded::Module1::A")
    send(@method, @base_dir + '/module1/a.rb').should be_true
    should be_loaded("Autoloaded::Module1::A")
  end

  it "accepts lists of files" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    send(@method, @file_list).should be_true
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "is totally cool with a splatted list of arguments" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    send(@method, *@file_list).should be_true
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all .rb files under a directory without a trailing slash" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, @base_dir).should be_true
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all .rb files under a directory with a trailing slash" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, "#{@base_dir}/").should be_true
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all files specified by a glob" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, "#{@base_dir}/**/*.rb").should be_true
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "returns false if an empty input was given" do
    send(@method, []).should be_false
    send(@method).should be_false
  end

  it "throws LoadError if no file or directory found" do
    lambda {send(@method, "not_found")}.should raise_error(LoadError)
  end
end

describe "require_all" do
  describe "dependency resolution" do
    it "handles load ordering when dependencies are resolvable" do
      require_all File.dirname(__FILE__) + '/fixtures/resolvable/*.rb'

      defined?(A).should == "constant"
      defined?(B).should == "constant"
      defined?(C).should == "constant"
      defined?(D).should == "constant"
    end

    it "raises NameError if dependencies can't be resolved" do
      proc do
        require_all File.dirname(__FILE__) + '/fixtures/unresolvable/*.rb'
      end.should raise_error(NameError)
    end
  end

  before(:all) {@method = :require_all}
  it_should_behave_like "#require_all syntactic sugar"
end

describe "require_rel" do
  it "provides require_all functionality relative to the current file" do
    require File.dirname(__FILE__) + '/fixtures/relative/b/b'

    defined?(RelativeA).should == "constant"
    defined?(RelativeB).should == "constant"
    defined?(RelativeC).should == "constant"
  end
end

describe "load_all" do
  it "provides require_all functionality but using 'load' instead of 'require'" do
    require_all File.dirname(__FILE__) + '/fixtures/resolvable'
    C.new.should be_cool

    class C
      def cool?
        false
      end
    end
    C.new.should_not be_cool

    load_all File.dirname(__FILE__) + '/fixtures/resolvable'
    C.new.should be_cool
  end

  before(:all) {@method = :load_all}
  it_should_behave_like "#require_all syntactic sugar"
end

describe "load_rel" do
  it "provides load_all functionality relative to the current file" do
    require File.dirname(__FILE__) + '/fixtures/relative/d/d'

    defined?(RelativeA).should == "constant"
    defined?(RelativeC).should == "constant"
    defined?(RelativeD).should == "constant"
    RelativeD.new.should be_ok

    class RelativeD
      def ok?
        false
      end
    end
    RelativeD.new.should_not be_ok

    load File.dirname(__FILE__) + '/fixtures/relative/d/d.rb'
    RelativeD.new.should be_ok
  end
end

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