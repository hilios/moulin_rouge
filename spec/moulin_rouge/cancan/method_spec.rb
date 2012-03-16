require 'spec_helper'

describe MoulinRouge::CanCan::Method do
  let(:name)    { :can }
  let(:args)    { [:one, :two] }
  let(:proc)    { Proc.new { :block } }
  let(:object)  { double(method.name => true) }
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
    it "sends this method to the given object" do
      object.should_receive(method.name).with(*method.args, &method.block)
      method.send_to(object)
    end

    it "evaluate any arguments that are proc" do
      method = MoulinRouge::CanCan::Method.new(:can, :do, :something, :on => proc)
      method.send_to(object)
      method.args.last[:on].should be(:block)
    end
  end
end