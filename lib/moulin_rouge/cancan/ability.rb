require 'cancan/ability'

module MoulinRouge
  module CanCan
    class Ability
      include ::CanCan::Ability
      
      def initialize(user)
        MoulinRouge::Group.list.each do |role, abilities|
          
        end
      end
    end
  end
end