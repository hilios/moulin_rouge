require 'spec_helper'

describe MoulinRouge::AbilityInfo do
  let(:args) { [:one, :two] }
  let(:proc) { Proc.new { :block } }
  let(:auth) { MoulinRouge::AbilityInfo.new(*args, &proc) }
  
  describe "#args" do
    it "is an attribute" do
      auth.args.should eq(args)
    end
  end
  
  describe "#block" do
    it "is an attribute" do
      auth.block.should eq(proc)
    end
  end
end