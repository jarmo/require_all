require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/require_shared.rb'

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