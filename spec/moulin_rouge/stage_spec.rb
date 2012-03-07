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
    it "returns nil when for main" do
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
    
    it "appends the content if the name is already present" do
      stage.role(:test) { can :do, :this }
      # Create one children
      stage.childrens.length.should be(1)
      # And one ability
      stage.childrens.first.abilities.length.should be(1)
      
      stage.role(:test) { can :do, :this }
      # Don't create other children
      stage.childrens.length.should be(1)
      # Append the new ability
      stage.childrens.first.abilities.length.should be(2)
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
  
  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe "#import" do
    let(:files_opened) { [] }
    
    it "glob all files in the given path and evaluate their content in the class scope" do
      File.stub(:open) { |file| files_opened << file; double("file", :read => "")  }
      stage.import(MoulinRouge.configuration.path)
      files_opened.should include(*Dir[MoulinRouge.configuration.path])
    end
  end
  
  describe "#find" do
    it "returns the instance of the stage if there is children with this name and nil otherwise" do
      role = stage.role(:test)
      stage.find(:test).should be(role)
      stage.find(:bad).should be_nil
    end
  end
  
  context "self" do
    describe "#main" do
      it "returns the main MoulinRouge::Stage instance" do
        MoulinRouge::Stage.main.should be_instance_of(stage.class)
      end
    end
  end
end