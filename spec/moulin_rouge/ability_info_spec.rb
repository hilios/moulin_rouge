require 'spec_helper'

describe MoulinRouge::AbilityInfo do
  let(:auth) { MoulinRouge::AbilityInfo.new([:arg], Proc.new { :block }) }
  
  describe "#args" do
    it "is an attribute" do
      auth.args.should eq([:arg])
    end
  end
  
  describe "#block" do
    it "is an attribute" do
      auth.block.should be_a(Proc)
    end
  end
end