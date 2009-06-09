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
end