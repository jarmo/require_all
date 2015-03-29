require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/require_shared.rb'

describe "require_all" do

  subject { self }

  describe "dependency resolution" do
    it "handles load ordering when dependencies are resolvable" do
      require_all File.dirname(__FILE__) + '/fixtures/resolvable/*.rb'

      is_expected.to be_loaded("A", "B", "C", "D")
    end

    it "raises NameError if dependencies can't be resolved" do
      expect do
        require_all File.dirname(__FILE__) + '/fixtures/unresolvable/*.rb'
      end.to raise_error(NameError)
    end
  end

  before(:all) do
    @base_dir = File.dirname(__FILE__) + '/fixtures/autoloaded'
    @method = :require_all
  end
  it_should_behave_like "#require_all syntactic sugar"
end

describe "require_rel" do

  subject { self }

  it "provides require_all functionality relative to the current file" do
    require File.dirname(__FILE__) + '/fixtures/relative/b/b'

    is_expected.to be_loaded("RelativeA", "RelativeB", "RelativeC")
    is_expected.not_to be_loaded("RelativeD")
  end

  before(:all) do
    @base_dir = './fixtures/autoloaded'
    @method = :require_rel
  end
  it_should_behave_like "#require_all syntactic sugar"
end
