require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/require_shared.rb'

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