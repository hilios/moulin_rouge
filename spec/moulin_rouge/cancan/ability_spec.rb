require 'spec_helper'

describe MoulinRouge::CanCan::Ability do
  let(:user)    { double("user") }
  let(:ability) { MoulinRouge::CanCan::Ability.new(user) }
  
  it "includes the CanCan::Ability module" do
    ability.should be_a(CanCan::Ability)
  end
end