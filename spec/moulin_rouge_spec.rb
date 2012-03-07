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
      let(:required_files) { [] }
      
      before(:each) do
        MoulinRouge.stub(:require) { |file| required_files << file }
        MoulinRouge.run
      end

      it "includes the dsl" do
        required_files.first.should eq("moulin_rouge/dsl")
      end

      it "require all files in the configuration path" do
        required_files.shift # Remove the DSL file
        required_files.should include(*Dir[MoulinRouge.configuration.path]) # Glob all files in the path
      end
    end
    
    context "(without stubs)" do
      before(:each) do
        MoulinRouge.run
      end
      
      it "evaluate all permissions in the path" do
        MoulinRouge::Group.list.should_not be_empty
      end
    end
  end
end