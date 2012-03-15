require 'spec_helper'

describe MoulinRouge::CanCan::Method do
  let(:name)    { :can }
  let(:args)    { [:one, :two] }
  let(:proc)    { Proc.new { :block } }
  let(:method)  { MoulinRouge::CanCan::Method.new(name, *args, &proc) }
  
  describe "#args" do
    it "is a reader attribute" do
      method.args.should eq(args)
    end
  end
  
  describe "#block" do
    it "is a reader attribute" do
      method.block.should eq(proc)
    end
  end

  describe "#name" do
    it "is a reader attribute" do
      method.name.should eq(name)
    end
  end

  describe "#send_to" do
    it "send this method to the given object" do
      object = double(method.name => true)
      object.should_receive(method.name).with(*method.args, &method.block)
      method.send_to(object)
    end
  end
end