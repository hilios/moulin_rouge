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
      let(:files) { Dir[MoulinRouge.configuration.path] } # Glob all files in the path
      let(:required_files) { [] }
      
      before(:each) do
        MoulinRouge::Stage.main.stub(:require) { |file| required_files << file }
        MoulinRouge.run
      end

      it "creates the main cointainer and require all files on config path" do
        required_files.should include(*files)
        MoulinRouge::Stage.main.should_not be_nil
      end
    end
    
    context "(without stubs)" do
      it "evaluate all permissions in the path" do
        pending
        MoulinRouge.run
        MoulinRouge::Stage.main.childrens.should_not be_empty
      end
    end
  end
end