require 'spec_helper'

describe MoulinRouge do
  it "is a module" do
    MoulinRouge.should be_a(Module)
  end
  
  context "self" do
    describe "#configuration" do
      it "returns the same object every time" do
        MoulinRouge.configuration.should equal(MoulinRouge.configuration)
      end
    end

    describe "#configure" do
      it "yields the current configuration" do
        MoulinRouge.configure do |config|
          config.should eq(MoulinRouge::configuration)
        end
      end
    end

    describe "#run!" do
      it "calls the load! method" do
        MoulinRouge.should_receive(:load!).twice # Here and inside spec_helpe.rb before(:each)
        MoulinRouge.run!
      end

      it "creates a class named Ability inherited from MoulinRouge::CanCan::Ability" do
        MoulinRouge.run!
        Object.const_get('Ability').should_not be_nil
        Object.const_get('Ability').ancestors.should include(MoulinRouge::CanCan::Ability)
      end
    end

    describe "#run?" do
      it "returns true if the run! method was called and false oterwise" do
        MoulinRouge.class_variable_set(:'@@run', false)
        MoulinRouge.run?.should be_false
        MoulinRouge.run!
        MoulinRouge.run?.should be_true
      end
    end

    describe "#load!" do
      it "compile authorizations" do
        MoulinRouge::Authorization.should_receive(:compile!).twice # Here and inside spec_helpe.rb before(:each)
        MoulinRouge.load!
      end
    end

    describe "reset!" do
      it "calls the reset! method on Authorization" do
        MoulinRouge::Authorization.should_receive(:reset!).twice # One in before(:each) inside spec_helper.rb and another here
        MoulinRouge.reset!
      end
    end

    describe "#reload!" do
      it "Reset all permissions and load them again" do
        MoulinRouge.should_receive(:reset!).twice # Here and inside spec_helpe.rb before(:each)
        MoulinRouge.should_receive(:load!).twice # Here and inside spec_helpe.rb before(:each)
        MoulinRouge.reload!
      end
    end
  end
end