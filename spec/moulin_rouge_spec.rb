require 'spec_helper'

describe MoulinRouge do
  it "should be a module" do
    MoulinRouge.should be_a(Module)
  end
  
  describe "#configuration" do
    it "returns the same object every time" do
      MoulinRouge.configuration.should equal(MoulinRouge.configuration)
    end
  end

  describe "#configure" do
    it "yields the current configuration" do
      MoulinRouge.configure do |config|
        config.should eq(MoulinRouge::configuration)
      end
    end
  end
  
  describe "#run" do
    context "(with stubs)" do
      it "call import the config path on the main stage" do
        MoulinRouge::Stage.main.should_receive(:import).with(MoulinRouge.configuration.path).once
        MoulinRouge.run
        MoulinRouge::Stage.main.should_not be_nil
      end
    end
    
    context "(without stubs)" do
      it "evaluate all permissions in the path" do
        
        MoulinRouge.run
        MoulinRouge::Stage.main.childrens.should_not be_empty
      end
    end
  end
end