require 'spec_helper'

describe MoulinRouge::Role::Array do
  let(:roles) { MoulinRouge::Role::Array.new }
  
  describe "#+ and #-" do
    it "pushs and remove the value from array" do
      # first add ...
      roles + :admin
      roles.should include(:admin)
      # ... them remove
      roles - :admin
      roles.should_not include(:admin)
    end
  end
  
  describe "#push" do
    it "not append if the value is already there" do
      roles.push(:admin)
      roles.length.should be(1)
      roles.push(:admin)
      roles.length.should be(1)
    end
  end
end