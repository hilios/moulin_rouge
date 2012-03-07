require 'cancan/ability'

module MoulinRouge
  module CanCan
    class Ability
      include ::CanCan::Ability
      
      def initialize(user)
      end
    end
  end
end