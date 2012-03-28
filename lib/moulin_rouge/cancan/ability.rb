require 'cancan'

module MoulinRouge
  module CanCan
    class Ability
      include ::CanCan::Ability
      # Define all permissions collect by MoulinRouge
      def initialize(model)
        model = MoulinRouge.configuration.model.new if model.nil? and not MoulinRouge.configuration.model.nil?
        # Reload all permissions if cache is disabled
        MoulinRouge.reload! unless MoulinRouge.configuration.cache
        # Set all abilities in main
        MoulinRouge::Authorization.main.abilities.each do |ability|
          ability.send_to(self, model)
        end
        # Set all abilities by role
        MoulinRouge::Authorization.abilities.each do |role, ability|
          ability.abilities.each do |cancan_ability|
            cancan_ability.send_to(self, model)
          end if model.send(MoulinRouge.configuration.test_method, role)
        end
      end
    end
  end
end