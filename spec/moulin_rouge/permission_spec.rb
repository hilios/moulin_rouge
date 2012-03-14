require 'spec_helper'

describe MoulinRouge::Permission do
  let(:permission) { MoulinRouge::Permission.new(:name) }

  describe "#initialize" do
    it "evaluate the groups and authorizations to the class scope" do
      permission = MoulinRouge::Permission.new(:scope) do
        self.class.should == MoulinRouge::Permission
        can :do, :something
        role :for
      end
    end
    
    it "append the new instance to Permission.all and Permission.names" do
      MoulinRouge::Permission.new(:main) do
        role(:one)
      end
      MoulinRouge::Permission.all.should include(:one)
      MoulinRouge::Permission.list.should include(:one)
    end
  end
  
  describe "#name" do
    it "returns the given name on class initialization" do
      permission.name.should be(:name)
    end
  end
  
  describe "#parent" do
    it "returns nil when for main" do
      permission.parent.should be_nil
    end
    
    it "returns a instance of the MoulinRouge::Permission" do
      another = MoulinRouge::Permission.new(:another, :parent => permission)
      another.parent.should be_a(MoulinRouge::Permission)
      another.parent.should be(permission)
    end
  end

  describe "#childrens" do
    it "returns an array" do
      permission.childrens.should be_an(Array)
    end
  end

  describe "#abilities" do
    it "returns an array" do
      permission.abilities.should be_a(Array)
    end
  end

  describe "#collect_abilities" do
    it "returns all abilities from self and their childrens" do
      permission.can :do, :this
      # First nested level
      one = permission.role(:one) do
        can :do, :one
      end
      # Second nested level
      two = one.role(:two) do
        can :do, :two
      end
      permission.collect_abilities.should be_an(Array)
      permission.collect_abilities.length.should be(3)
      one.collect_abilities.length.should be(2)
      two.collect_abilities.length.should be(1)
    end
  end
  
  describe "#role" do
    it "returns a new permission with the parent setted to the class that are calling" do
      role = permission.role(:test)
      role.should be_a(MoulinRouge::Permission)
      role.parent.should be(permission)
    end

    it "adds a new instance on children" do
      permission.childrens.should be_empty
      permission.role(:name)
      permission.childrens.should_not be_empty
    end
    
    it "appends the content if the name is already present" do
      permission.role(:test) { can :do, :this }
      # should create one children ...
      permission.childrens.length.should be(1)
      # ... and one ability
      permission.childrens.first.abilities.length.should be(1)
      
      permission.role(:test) { can :do, :this }
      # should not create other children ...
      permission.childrens.length.should be(1)
      # ... and append the new ability
      permission.childrens.first.abilities.length.should be(2)
    end
  end

  describe "#group" do
    
  end
  
  describe "#can" do
    let(:args) { [:one, :two] }
    let(:proc) { Proc.new { :block } }
    
    it "stores the given arguments and block into abilities array" do
      permission.can(:do, :something) { :block }
      permission.abilities.should_not be_empty
      permission.abilities.first.should be_a(MoulinRouge::AbilityInfo)
      # Evaluate the class of the arguments and block
      permission.abilities.first.args.should be_a(Array)
      permission.abilities.first.block.should be_a(Proc)
      # Just check the value
      permission.abilities.first.args.should eq([:do, :something])
      permission.abilities.first.block.call.should be(:block)
    end
    
    it "stores nil on block attribute when no block is given" do
      permission.can(:do, :something)
      permission.abilities.first.block.should be_nil
    end

    it "adds a new ability to this permission" do
      permission.abilities.should be_empty
      permission.can(:do, :something)
      permission.abilities.should_not be_empty
    end
  end
  
  describe "#import" do
    let(:files_opened) { [] }
    
    it "glob all files in the given path and evaluate their content in the class scope" do
      File.stub(:open) { |file| files_opened << file; double("file", :read => "")  }
      permission.import(MoulinRouge.configuration.path)
      files_opened.should include(*Dir[MoulinRouge.configuration.path])
    end
    
    it "let raise exceptions when there are syntax errors" do
      tests = []
      tests << %|
        # Wrong method name
        roe :name do
        end
      |
      tests << %|
        # Wrong method name
        groups :name do
        end
      |
      tests << %|
        # Wrong method name
        cn :
      |
      tests << %|
        # Wrong method name
        role do
        end
      |
      # Execute them all
      tests.each do |test|
        create_permission test
        lambda { permission.import(MoulinRouge.configuration.path) }.should raise_error
      end
    end
  end
  
  describe "#find" do
    it "returns the instance of the permission if there is children with this name and nil otherwise" do
      role = permission.role(:test)
      permission.find(:test).should be(role)
      permission.find(:bad).should be_nil
    end
  end
  
  describe "#name" do
    it "returns an symbol containing the name with the parents separeted by a underscore" do
      first_children, second_children = nil
      MoulinRouge::Permission.new(:main) do
        first_children = role(:one) do
          second_children = role(:two)
        end
      end
      first_children.name.should be(:one)
      second_children.name.should be(:one_two)
    end
  end

  describe "#include" do
    it "appends all childrens and abilities from one object to another" do
      one, another = nil
      one = permission.role(:one) do
        role(:nested)
        can :do, :something
      end
      another = permission.role(:another) do
        include :one
      end
      another.childrens.should_not be_empty
      another.abilities.should_not be_empty
      another.childrens.first.singular_name.should be(:nested)
      another.abilities.first.args.should include(:do, :something)
    end

    it "raises an error if could not find the requested permission" do
      lambda {
        permission.role(:name) do
          include :not_found
        end
      }.should raise_error(MoulinRouge::PermissionNotFound)
    end
  end
  
  context "self" do
    describe "#main" do
      it "returns the main MoulinRouge::Permission instance" do
        MoulinRouge::Permission.main.should be_instance_of(permission.class)
      end
    end

    describe "#list" do
      it "returns an array" do
        MoulinRouge::Permission.list.should be_a(Array)
      end
    end

    describe "#all" do
      it "returns an hash with all created permissions" do
        MoulinRouge::Permission.all.should be_a(Hash)
      end

      it "store all permissions instantiated unless the main one" do
        hello_world = permission.role(:hello_world) do
          can :do
        end
        MoulinRouge::Permission.all[hello_world.name].should be(hello_world)
      end
    end

    describe "#add" do
      it "should append the object instance on Permission.all and Permission.names" do
        object = double(:name => :foo)
        MoulinRouge::Permission.stub(:all)    { @all  ||= double()   }
        MoulinRouge::Permission.stub(:list)   { @list ||= double(:include? => false) }
        MoulinRouge::Permission.list.should_receive(:'<<').with(object.name)
        MoulinRouge::Permission.all.should_receive(:'[]=').with(object.name, object)
        MoulinRouge::Permission.add(object)
      end
    end
  end
end