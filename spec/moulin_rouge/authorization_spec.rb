require 'spec_helper'

describe MoulinRouge::Authorization do
  let(:ability) { MoulinRouge::Ability.new(:name) }

  context "self" do
    describe "#method_missing" do
      it "delegates any missing method to the main ability class" do
        MoulinRouge::Authorization.main.should_receive(:role).with(:test)
        MoulinRouge::Authorization.main.should_receive(:can).with(:test)
        MoulinRouge::Authorization.role(:test)
        MoulinRouge::Authorization.can(:test)
      end
    end

    describe "#main" do
      it "returns the main MoulinRouge::Authorization instance" do
        MoulinRouge::Authorization.main.should be_instance_of(ability.class)
      end
    end

    describe "#list" do
      it "returns an array" do
        MoulinRouge::Authorization.roles.should be_a(Array)
      end
    end

    describe "#all" do
      it "returns an hash with all created abilitys" do
        MoulinRouge::Authorization.abilities.should be_a(Hash)
      end

      it "store all abilitys instantiated unless the main one" do
        hello_world = ability.role(:hello_world) do
          can :do
        end
        MoulinRouge::Authorization.abilities[hello_world.name].should be(hello_world)
      end
    end

    describe "#add" do
      it "should append the object instance on Authorization.all and Authorization.names" do
        object = double(:name => :foo)
        MoulinRouge::Authorization.stub(:abilities) { @abilities  ||= double() }
        MoulinRouge::Authorization.stub(:roles)     { @roles      ||= double(:include? => false) }
        MoulinRouge::Authorization.abilities.should_receive(:'[]=').with(object.name, object)
        MoulinRouge::Authorization.roles.should_receive(:'<<').with(object.name)
        MoulinRouge::Authorization.register(object)
      end
    end

    describe "#compile!" do
      let(:files_loaded) { [] }

      it "load all files in the configuration path" do
        Kernel.stub(:load) { |file| files_loaded << file }
        MoulinRouge::Authorization.compile!
        files_loaded.should include(*Dir[MoulinRouge.configuration.path])
      end

      it "should load all roles defined into the Authorization abilities" do
        MoulinRouge::Authorization.roles.should be_empty
        MoulinRouge::Authorization.compile!
        p SpecAuthorization
        MoulinRouge::Authorization.roles.should_not be_empty
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
          create_authorization test
          lambda { ability.import(MoulinRouge.configuration.path) }.should raise_error
        end
      end
    end

    describe "#reset!" do
      it "sets to nil the main, role and abilities instance variables" do
        # Create some
        ability.role(:one)
        ability.role(:two)
        MoulinRouge::Authorization.abilities.should_not be_empty
        MoulinRouge::Authorization.roles.should_not be_empty
        # Apply
        MoulinRouge::Authorization.reset!
        # Evaluate constants
        MoulinRouge::Authorization.instance_variable_get(:'@main').should be_nil
        MoulinRouge::Authorization.instance_variable_get(:'@abilities').should be_nil
        MoulinRouge::Authorization.instance_variable_get(:'@roles').should be_nil
        # Evaluate has arrays
        MoulinRouge::Authorization.abilities.should be_empty
        MoulinRouge::Authorization.roles.should be_empty
      end
    end

    describe "#new" do
      it "raises an error because the class only act as a singleton" do
        lambda { MoulinRouge::Authorization.new }.should raise_error(NoMethodError)
      end
    end
  end
end