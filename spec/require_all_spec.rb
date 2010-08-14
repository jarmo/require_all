require File.dirname(__FILE__) + '/../lib/require_all.rb'

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

  describe "syntactic sugar" do
    before :each do
      @base_dir = File.dirname(__FILE__) + '/fixtures/resolvable'
      @file_list = ['b.rb', 'c.rb', 'a.rb', 'd.rb'].map { |f| "#{@base_dir}/#{f}" }
    end

    it "accepts files with and without extensions" do
      require_all(@base_dir + '/c').should be_true
      require_all(@base_dir + '/a.rb').should be_true
    end

    it "accepts lists of files" do
      require_all(@file_list).should be_true
    end

    it "is totally cool with a splatted list of arguments" do
      require_all(*@file_list).should be_true
    end

    it "will load all .rb files under a directory without a trailing slash" do
      require_all(@base_dir).should be_true
    end

    it "will load all .rb files under a directory with a trailing slash" do
      require_all("#{@base_dir}/").should be_true
    end

    it "will load all files specified by a glob" do
      require_all("#{@base_dir}/**/*.rb").should be_true
    end

    it "returns false if an empty input was given" do
      require_all([]).should be_false
      require_all.should be_false
    end

    it "throws LoadError if no file or directory found" do
      lambda {require_all("not_found")}.should raise_error(LoadError)
    end
  end
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
