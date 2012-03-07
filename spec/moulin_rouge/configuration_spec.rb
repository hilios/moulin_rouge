require 'spec_helper'

describe MoulinRouge::Configuration do
  let(:config) { MoulinRouge::Configuration.new }
  
  describe "#path" do
    it "returns a string" do
      config.path.should be_a(String)
    end
  end
  
  describe "#path=" do
    it "set the value of" do
      config.path = "test"
      config.path.should eq("test")
    end
  end
end