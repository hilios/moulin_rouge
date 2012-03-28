require 'spec_helper'

describe MoulinRouge::Ability do
  let(:ability) { MoulinRouge::Ability.new(:name) }

  describe "#initialize" do
    it "evaluate the groups and authorizations to the class scope" do
      ability = MoulinRouge::Ability.new(:scope) do
        self.class.should == MoulinRouge::Ability
        can :do, :something
        role :for
      end
    end
    
    it "registers the ability instance into authorization" do
      MoulinRouge::Authorization.should_receive(:register)
      MoulinRouge::Ability.new(:main) do
        role(:one)
      end
    end

    it "inherits all abilities from parent if this is a group" do
      role = nil
      MoulinRouge::Ability.new(:main) do
        group(:group) do
          can :do, :this
          role = role(:role)
        end
      end
      role.abilities.first.args.should include(:do, :this)
    end
  end
  
  describe "#name" do
    it "returns the given name on class initialization" do
      ability.name.should be(:name)
    end
  end
  
  describe "#parent" do
    it "returns nil when for main" do
      ability.parent.should be_nil
    end
    
    it "returns a instance of the MoulinRouge::Ability" do
      another = MoulinRouge::Ability.new(:another, :parent => ability)
      another.parent.should be_a(MoulinRouge::Ability)
      another.parent.should be(ability)
    end
  end

  describe "#childrens" do
    it "returns an array" do
      ability.childrens.should be_an(Array)
    end
  end

  describe "#abilities" do
    it "returns an array" do
      ability.abilities.should be_a(Array)
    end
  end

  describe "#inherithed_abilities" do
    it "returns all abilities from self and their childrens" do
      ability.can :do, :this
      # First nested level
      one = ability.role(:one) do
        can :do, :one
      end
      # Second nested level
      two = one.role(:two) do
        can :do, :two
      end
      ability.inherithed_abilities.should be_an(Array)
      ability.inherithed_abilities.length.should be(3)
      one.inherithed_abilities.length.should be(2)
      two.inherithed_abilities.length.should be(1)
    end
  end
  
  describe "#role" do
    it "returns a new ability with the parent setted to the class that are calling" do
      role = ability.role(:test)
      role.should be_a(MoulinRouge::Ability)
      role.parent.should be(ability)
    end

    it "adds a new instance on children" do
      ability.childrens.should be_empty
      ability.role(:name)
      ability.childrens.should_not be_empty
    end
    
    it "appends the content if the name is already present" do
      ability.role(:test) { can :do, :this }
      # should create one children ...
      ability.childrens.length.should be(1)
      # ... and one ability
      ability.childrens.first.abilities.length.should be(1)
      
      ability.role(:test) { can :do, :this }
      # should not create other children ...
      ability.childrens.length.should be(1)
      # ... and append the new ability
      ability.childrens.first.abilities.length.should be(2)
    end
  end

  describe "#group" do
    it "not add the group name to ability list" do
      ability.group(:test)
      MoulinRouge::Authorization.abilities.should_not include(:test)
    end
  end

  describe "#group?" do
    it "returns true if is a group and false otherwise" do
      role = ability.role(:role)
      group = ability.group(:group)
      role.group?.should be_false
      group.group?.should be_true
    end
  end

  describe "#method_missing" do
    let(:args) { [:one, :two] }
    let(:proc) { Proc.new { :block } }

    context "collect all cancan methods and store under abilities" do
      MoulinRouge::Ability::CANCAN_METHODS.each do |method_name|
        describe "##{method_name}" do
          it "adds a new ability to this ability" do
            ability.abilities.should be_empty
            ability.send(method_name, *args, &proc)
            ability.abilities.should_not be_empty
          end

          it "stores nil on block attribute when no block is given" do
            ability.send(method_name, *args)
            ability.abilities.first.block.should be_nil
          end

          it "stores the method" do
            ability.abilities.should be_empty
            ability.send(method_name, *args, &proc)
            ability.abilities.should_not be_empty

            method = ability.abilities.first
            method.should be_a(MoulinRouge::CanCan::Method)
            # Evaluate the class of the arguments and block
            method.args.should be_a(Array)
            method.block.should be_a(Proc)
            # Just check the value
            method.args.should eq(args)
            method.block.call.should be(:block)
          end
        end
      end
    end

    it "receives and stores in a proc calls on the model object" do
      cancan_ability = nil
      ability.role(:test) do
        cancan_ability = can :do, :this, :user_id => current_user.id
      end
      cancan_ability.args.last[:user_id].should be_a(Proc)
    end

    it "raise an error if the method is not registered has a cancan method" do
      lambda { ability.send(:abcdefg, *args, &proc) }.should raise_error(NoMethodError)
    end
  end
  
  describe "#find" do
    it "returns the instance of the ability if there is children with this name and nil otherwise" do
      role = ability.role(:test)
      ability.find(:test).should be(role)
      ability.find(:bad).should be_nil
    end
  end
  
  describe "#name" do
    it "returns an symbol containing the name with the parents separeted by a underscore" do
      first_children, second_children = nil
      MoulinRouge::Ability.new(:main) do
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
      one = ability.role(:one) do
        role(:nested)
        can :do, :something
      end
      another = ability.role(:another) do
        include :one
      end
      another.childrens.should_not be_empty
      another.abilities.should_not be_empty
      another.childrens.first.singular_name.should be(:nested)
      another.abilities.first.args.should include(:do, :something)
    end

    it "raises an error if could not find the requested ability" do
      lambda {
        ability.role(:name) do
          include :not_found
        end
      }.should raise_error(MoulinRouge::RoleNotFound)
    end
  end
end