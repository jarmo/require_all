require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/require_shared.rb'

describe "require_all" do

  subject { self }

  context "when files correctly declare their dependencies" do
    it "requires them successfully" do
      require_all fixture_path('resolvable/*.rb')

      is_expected.to be_loaded("A", "B", "C", "D")
    end
  end

  context "errors" do
    it "raises RequireAll:LoadError if files do not declare their dependencies" do
      expect do
        require_all fixture_path('unresolvable/*.rb')
      end.to raise_error(RequireAll::LoadError) do |error|
        expect(error.cause).to be_a NameError
        expect(error.message).to match /Please require the necessary files/
      end
    end

    it "raises other NameErrors if encountered" do
      expect do
        require_all fixture_path('error')
      end.to raise_error(NameError) do |error|
        expect(error.message).to match /undefined local variable or method `non_existent_method'/
      end
    end
  end

  before(:all) do
    @base_dir = fixture_path('autoloaded')
    @method = :require_all
  end
  it_should_behave_like "#require_all syntactic sugar"
end

describe "require_rel" do

  subject { self }

  it "provides require_all functionality relative to the current file" do
    require fixture_path('relative/b/b')

    is_expected.to be_loaded("RelativeA", "RelativeB", "RelativeC")
    is_expected.not_to be_loaded("RelativeD")
  end

  before(:all) do
    @base_dir = relative_fixture_path('autoloaded')
    @method = :require_rel
  end
  it_should_behave_like "#require_all syntactic sugar"
end
