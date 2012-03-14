require 'spec_helper'

describe MoulinRouge::CanCan::Ability do
  let(:test_method) { MoulinRouge.configuration.test_method.to_sym }
  let(:model)       { double("model", test_method => true) }
  let(:ability)     { MoulinRouge::CanCan::Ability.new(model) }
  let(:permission)  { MoulinRouge::Permission.main }

  before(:each) do
    # The current permission will create the following abilities 
    # for each role because of nested rules:
    #               => can(:do, :this) # for everybody
    # :first        => can(:do, :something_else), can(:do, :something)
    # :first_second => can(:do, :something_else)
    permission.can(:do, :this)
    permission.role(:first) do
      can(:do, :something)
      role(:second) do
        can(:do, :something_else)
      end
    end
  end
  
  it "includes the CanCan::Ability module" do
    ability.should be_a(CanCan::Ability)
  end

  it "call test_method in model for each permission" do
    model.should_receive(test_method).with(:first)
    model.should_receive(test_method).with(:first_second)
    ability
  end

  it "call can method for each ability of the permission" do
    # First all permissions in main
    MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:do, :this).once
    # Please read the expetations explanation at before(:each) method
    MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:do, :something).once
    MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(:do, :something_else).twice
    ability # Execute
  end

  it "should execute the can method with exactly the same arguments and block that was stored" do
    permission.collect_abilities.each do |ability|
      MoulinRouge::CanCan::Ability.any_instance.should_receive(:can).with(*ability.args, &ability.block).at_least(:once)
    end
    ability # Execute
  end

  it "reloads all permissions when cache is set to false" do
    MoulinRouge.configuration.cache = false
    MoulinRouge.should_receive(:reset!).twice # One in the before(:each) in spec_helper.rb and another here
    ability # Execute
  end
end