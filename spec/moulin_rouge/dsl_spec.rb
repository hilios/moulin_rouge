require 'spec_helper'

describe MoulinRouge::DSL do
  describe "#role" do
    it "returns an new permission with the parent setted to nil" do
      permission = role(:test)
      permission.should be_instance_of(MoulinRouge::Group)
      permission.parent.should be_nil
    end
  end
end