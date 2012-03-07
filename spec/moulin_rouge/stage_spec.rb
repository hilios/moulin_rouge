require 'spec_helper'

describe MoulinRouge::Stage do
  let(:stage) { MoulinRouge::Stage.new(:name) }

  describe "#initialize" do
    it "evaluate the groups and authorizations to the class scope" do
      stage = MoulinRouge::Stage.new(:scope) do
        self.class.should == MoulinRouge::Stage
        can :do, :something
        role :for
      end
    end
  end
  
  describe "#name" do
    it "returns the given name on class initialization" do
      stage.name.should be(:name)
    end
  end
  
  describe "#parent" do
    it "returns nil when for root" do
      stage.parent.should be_nil
    end
    
    it "returns a instance of the MoulinRouge::Stage" do
      another = MoulinRouge::Stage.new(:another, stage)
      another.parent.should be_instance_of(MoulinRouge::Stage)
      another.parent.should be(stage)
    end
  end

  describe "#childrens" do
    it "returns an array" do
      stage.childrens.should be_instance_of(Array)
    end
  end

  describe "#authorizations" do
    it "returns an array" do
      stage.abilities.should be_a(Array)
    end
  end
  
  describe "#role" do
    it "returns a new stage with the parent setted to the class that are calling" do
      role = stage.role(:test)
      role.should be_instance_of(MoulinRouge::Stage)
      role.parent.should be(stage)
    end

    it "adds a new instance on children" do
      stage.childrens.should be_empty
      stage.role(:name)
      stage.childrens.should_not be_empty
    end
  end
  
  describe "#can" do
    it "stores the given arguments and block into abilities array" do
      stage.can(:do, :something) { :block }
      stage.abilities.should_not be_empty
      stage.abilities.first.should be_a(MoulinRouge::AbilityInfo)
      stage.abilities.first.block.should be_a(Proc)
      stage.abilities.first.args.should be_a(Array)
      stage.abilities.first.args.should eq([:do, :something])
    end
    
    it "stores nil on block attribute when no block is given" do
      stage.can(:do, :something)
      stage.abilities.first.block.should be_nil
    end

    it "adds a new ability to this stage" do
      stage.abilities.should be_empty
      stage.can(:do, :something)
      stage.abilities.should_not be_empty
    end
  end
  
  context "self" do
    describe "#root" do
      it "holds the root MoulinRouge::Groups instances" do
        stage
        MoulinRouge::Stage.root.should be(stage)
      end
    end
  end
end