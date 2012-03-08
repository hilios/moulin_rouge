require 'spec_helper'

class User
  include MoulinRouge::Role::Base
end

describe MoulinRouge::Role::Base do
  let(:user)  { User.new }
  subject     { user }
  
  describe "#roles" do
    it "returns an array with the assigned roles" do
      user.roles.should be_a(Array)
    end
  end
end