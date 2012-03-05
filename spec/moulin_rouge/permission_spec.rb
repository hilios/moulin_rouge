require 'spec_helper'

describe MoulinRouge::Permission do
  let(:permission) { MoulinRouge::Permission.new(:name) }
  
  describe "#initialize" do
    it "evaluate the permissions and authorizations to the class scope" do
      permission = MoulinRouge::Permission.new(:scope) do
        can :do, :something
        role :for
      end
    end
  end
  
  describe "#name" do
    it "returns the given name on class initialization" do
      permission.name.should be(:name)
    end
  end
  
  describe "#parent" do
    it "returns nil when for root permissions" do
      permission.parent.should be_nil
    end
    
    it "return a instance of the MoulinRouge::Permission" do
      another = MoulinRouge::Permission.new(:another, permission)
      another.parent.should be_instance_of(MoulinRouge::Permission)
      another.parent.should be(permission)
    end
  end
  
  describe "#role" do
    it "returns a new permission with the parent setted to the class that are calling" do
      role = permission.role(:test)
      role.should be_instance_of(MoulinRouge::Permission)
      role.parent.should be(permission)
    end
  end
  
  describe "#authorizations" do
    it "returns an array" do
      permission.authorizations.should be_a(Array)
    end
  end
  
  describe "#can" do
    it "stores the given arguments and block into authorizations array" do
      permission.can(:do, :something) { :block }
      permission.authorizations.should_not be_empty
      permission.authorizations.first.should be_a(MoulinRouge::Authorization)
      permission.authorizations.first.block.should be_a(Proc)
      permission.authorizations.first.args.should be_a(Array)
      permission.authorizations.first.args.should eq([:do, :something])
    end
    
    it "stores nil on block attribute when no block is given" do
      permission.can(:do, :something)
      permission.authorizations.first.block.should be_nil
    end
  end
  
  context "singleton" do
    describe "#list" do
      it "holds all MoulinRouge::Permissions instances created" do
        permission
        MoulinRouge::Permission.list.should include(permission)
      end
    end
  end
end