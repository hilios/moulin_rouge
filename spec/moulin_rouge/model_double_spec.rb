require 'spec_helper'

describe MoulinRouge::ModelDouble do
  let(:model) { MoulinRouge::ModelDouble.new }
  
  it "returns an proc for every method called in this class" do
    model.id.should be_a(Proc)
    model.abc.should be_a(Proc)
  end
  
  it "the proc sends the methods to the given scope with all arguments" do
    object = double(:id => true)
    object.should_receive(:id).with(:this).once
    model.id(:this).call(object)
  end
end