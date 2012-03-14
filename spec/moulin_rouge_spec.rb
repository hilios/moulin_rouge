require 'spec_helper'

describe MoulinRouge do
  it "should be a module" do
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
        MoulinRouge.should_receive(:load!).once
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
      context "(with stubs)" do
        it "call import the config path on the main permission" do
          MoulinRouge::Permission.main.should_receive(:import).with(MoulinRouge.configuration.path).once
          MoulinRouge.load!
          MoulinRouge::Permission.main.should_not be_nil
        end
      end

      context "(without stubs)" do
        it "evaluate all permissions in the path" do
          MoulinRouge.load!
          MoulinRouge::Permission.main.childrens.should_not be_empty
        end
      end
    end

    describe "#reload!" do
      it "Reset all permissions and load them again" do
        MoulinRouge::Permission.should_receive(:reset!).at_least(:once)
        MoulinRouge.should_receive(:load!).once
        MoulinRouge.reload!
      end
    end
  end
end