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
        # Set all permissions in main
        MoulinRouge::Permission.main.abilities.each do |ability|
          ability.send_to(self)
        end
        # Set all permissions by roles
        MoulinRouge::Permission.all.each do |role, permission|
          permission.abilities.each do |ability|
            ability.send_to(self)
          end if model.send(MoulinRouge.configuration.test_method, role)
        end
      end
    end
  end
end