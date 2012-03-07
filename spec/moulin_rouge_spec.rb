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
      let(:files) { Dir[MoulinRouge.configuration.path] }
      let(:runner) { MoulinRouge.run }
      let(:required_files) { [] }
      
      before(:each) do
        MoulinRouge::Stage.any_instance.stub(:require) { |file| required_files << file }
        MoulinRouge::Stage.any_instance.stub(:required_files) { required_files }
      end

      it "creates the main cointainer and require all files on config path" do
        pending
        # runner.should_receive(:require).at_least(files.length)
      end

      it "require all files in the configuration path" do
        runner.required_files.should include(*files) # Glob all files in the path
      end
    end
    
    context "(without stubs)" do
      before(:each) do
        MoulinRouge.run
      end
      
      it "evaluate all permissions in the path" do
        pending
        # MoulinRouge::Stage.main.childrens.should_not be_empty
      end
    end
  end
end