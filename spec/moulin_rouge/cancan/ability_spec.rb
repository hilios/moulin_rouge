require 'spec_helper'

describe MoulinRouge::CanCan::Ability do
  let(:test_method) { MoulinRouge.configuration.test_method.to_sym }
  let(:model)       { double("model", test_method => true) }
  let(:ability)     { MoulinRouge::CanCan::Ability.new(model) }
  let(:permission)  { MoulinRouge::Permission.main }

  before(:each) do
    MoulinRouge::CanCan::Ability.any_instance.stub(:can) { true }
    # The current permission will create the following abilities 
    # for each role because of nested rules:
    #               => can(:do, :this) # for everybody
    # :role         => can(:do, :something)
    # :role_nested  => can(:create, :something)
    # :group_nested => can(:read, :something), can(:edit, :something)
    permission.can(:do, :this)
    permission.role(:role) do
      can(:do, :something)

      role(:nested) do
        can(:create, :something)
      end
    end
    permission.group(:group) do
      can :read, :something

      role(:nested) do
        can :edit, :something
      end
    end
  end
  
  it "includes the CanCan::Ability module" do
    ability.should be_a(CanCan::Ability)
  end

  describe "#initialize" do
    it "call test_method in model for each permission" do
      model.should_receive(test_method).with(:role)
      model.should_receive(test_method).with(:role_nested)
      model.should_receive(test_method).with(:group_nested)
      ability
    end

    it "call can method for each ability of the permission" do
      # First all permissions in main
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:do, :this).once
      # Please read the expetations explanation at before(:each) method
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:do, :something).once
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:create, :something).once
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:read, :something).once
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:edit, :something).once
      ability # Execute
    end

    it "executes the can method with exactly the same arguments and block that was stored" do
      # Concat permissions from main and from all defined classes
      abilities = permission.abilities + MoulinRouge::Permission.all.values.map(&:abilities)
      abilities.flatten.each do |ability|
        MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(*ability.args, &ability.block).at_least(:once)
      end
      ability # Execute
    end

    it "reloads all permissions when cache is set to false" do
      MoulinRouge.configuration.cache = false
      MoulinRouge.should_receive(:reload!).once
      ability # Execute
    end

    it "creates a new instance of model if the config is not nil and the initializer argument is also nil" do
      klass = Class.new
      klass.stub(:new) { model }
      # Test
      klass.should_receive(:new).once
      MoulinRouge.configuration.model = klass
      MoulinRouge::CanCan::Ability.new(nil)
    end
  end
end