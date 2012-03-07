require 'spec_helper'

describe MoulinRouge::Group do
  let(:group) { MoulinRouge::Group.new(:name) }
  
  describe "#initialize" do
    it "evaluate the groups and authorizations to the class scope" do
      group = MoulinRouge::Group.new(:scope) do
        self.class.should == MoulinRouge::Group
        can :do, :something
        role :for
      end
    end
  end
  
  describe "#name" do
    it "returns the given name on class initialization" do
      group.name.should be(:name)
    end
  end
  
  describe "#parent" do
    it "returns nil when for root" do
      group.parent.should be_nil
    end
    
    it "return a instance of the MoulinRouge::Group" do
      another = MoulinRouge::Group.new(:another, group)
      another.parent.should be_instance_of(MoulinRouge::Group)
      another.parent.should be(group)
    end
  end

  describe "#childrens" do
    it "returns an array" do
      group.childrens.should be_instance_of(Array)
    end
  end
  
  describe "#role" do
    it "returns a new group with the parent setted to the class that are calling" do
      role = group.role(:test)
      role.should be_instance_of(MoulinRouge::Group)
      role.parent.should be(group)
    end
  end
  
  describe "#authorizations" do
    it "returns an array" do
      group.abilities.should be_a(Array)
    end
  end
  
  describe "#can" do
    it "stores the given arguments and block into abilities array" do
      group.can(:do, :something) { :block }
      group.abilities.should_not be_empty
      group.abilities.first.should be_a(MoulinRouge::AbilityInfo)
      group.abilities.first.block.should be_a(Proc)
      group.abilities.first.args.should be_a(Array)
      group.abilities.first.args.should eq([:do, :something])
    end
    
    it "stores nil on block attribute when no block is given" do
      group.can(:do, :something)
      group.abilities.first.block.should be_nil
    end
  end
  
  context "singleton" do
    describe "#list" do
      it "holds all MoulinRouge::Groups instances created" do
        group
        MoulinRouge::Group.list.should include(group)
      end
    end
  end
end