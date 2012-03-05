require 'spec_helper'

describe MoulinRouge::Ability do
  let(:auth) { MoulinRouge::Ability.new([:arg], Proc.new { :block }) }
  
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