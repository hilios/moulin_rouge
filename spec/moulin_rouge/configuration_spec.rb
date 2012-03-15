require 'spec_helper'

describe MoulinRouge::Configuration do
  let(:config) { MoulinRouge::Configuration.new }
  
  describe "#path" do
    it "returns a string" do
      config.path.should be_a(String)
    end
  end
  
  describe "#path=" do
    it "sets the value" do
      config.path = "test"
      config.path.should eq("test")
    end
  end

  describe "#test_method" do
    it "returns a symbol" do
      config.test_method.should be_a(Symbol)
    end
  end
  
  describe "#test_method=" do
    it "sets the value" do
      config.test_method = :"test"
      config.test_method.should eq(:"test")
    end
  end

  describe "#cache" do
    it "returns a boolean" do
      config.cache.should be_true
    end
  end
  
  describe "#cache=" do
    it "sets the value" do
      config.cache = false
      config.cache.should eq(false)
    end
  end

  describe "#model_instance" do
    it "returns a boolean" do
      config.model_instance.should be_a(Symbol)
    end
  end
  
  describe "#model_instance=" do
    it "sets the value" do
      config.model_instance = :user
      config.model_instance.should eq(:user)
    end
  end
end