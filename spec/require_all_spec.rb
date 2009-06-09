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
    before :all do
      @base_dir = File.dirname(__FILE__) + '/fixtures/resolvable/'
    end
    
    it "works like a drop-in require replacement" do
      require_all @base_dir + 'c.rb'
      defined?(C).should == "constant"
    end
    
    it "accepts lists of files" do
      require_all ['b.rb', 'c.rb', 'a.rb', 'd.rb'].map { |f| @base_dir + f }
    end
  end
end