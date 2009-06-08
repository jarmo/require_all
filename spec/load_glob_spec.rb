require File.dirname(__FILE__) + '/../lib/load_glob.rb'

describe "load_glob" do    
  it "handles load ordering when dependencies are resolvable" do
    load_glob File.dirname(__FILE__) + '/fixtures/resolvable/*.rb'
    
    defined?(A).should == "constant"
    defined?(B).should == "constant"
    defined?(C).should == "constant"
    defined?(D).should == "constant"
  end
  
  it "raises NameError if dependencies can't be resolved" do
    proc do 
      load_glob File.dirname(__FILE__) + '/fixtures/unresolvable/*.rb'
    end.should raise_error(NameError)
  end
end