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
    let(:required_files) { [] }
    
    before do
      MoulinRouge.stub(:require) { |file| required_files << file }
      MoulinRouge.run
    end
    
    it "loads the dsl at first" do
      required_files.first.should eq("moulin_rouge/dsl")
    end
    
    it "loads all the files in the configuration path" do
      required_files.shift # Remove the dsl
      glob_path = Dir[MoulinRouge.configuration.path] # Glob all files in the path
      glob_path.each do |file|
        required_files.should include(file)
      end
    end
  end
end