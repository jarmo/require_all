require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/require_shared.rb'

describe "load_all" do
  
  subject { self }

  it "provides require_all functionality but using 'load' instead of 'require'" do
    require_all File.dirname(__FILE__) + '/fixtures/resolvable'
    expect(C.new).to be_cool

    class C
      remove_method :cool?
      def cool?
        false
      end
    end
    expect(C.new).not_to be_cool
    C.send :remove_method, :cool?

    load_all File.dirname(__FILE__) + '/fixtures/resolvable'
    expect(C.new).to be_cool
  end

  before(:all) do
    @base_dir = File.dirname(__FILE__) + '/fixtures/autoloaded'
    @method = :load_all
  end
  it_should_behave_like "#require_all syntactic sugar"
end

describe "load_rel" do

  subject { self }

  it "provides load_all functionality relative to the current file" do
    require File.dirname(__FILE__) + '/fixtures/relative/d/d'

    is_expected.to be_loaded("RelativeA", "RelativeC", "RelativeD")
    expect(RelativeD.new).to be_ok

    class RelativeD
      remove_method :ok?
      def ok?
        false
      end
    end
    expect(RelativeD.new).not_to be_ok
    RelativeD.send :remove_method, :ok?

    load File.dirname(__FILE__) + '/fixtures/relative/d/d.rb'
    expect(RelativeD.new).to be_ok
  end

  before(:all) do
    @base_dir = './fixtures/autoloaded'
    @method = :load_rel
  end
  it_should_behave_like "#require_all syntactic sugar"
end
