require 'cancan'

module MoulinRouge
  module CanCan
    class Ability
      include ::CanCan::Ability
      # Define all permissions collect by MoulinRouge
      def initialize(model)
        MoulinRouge.reset! unless MoulinRouge.configuration.cache
        # Set all permissions in main
        MoulinRouge::Permission.main.abilities.each do |ability|
          can(*ability.args, &ability.block)
        end
        # Set all permissions by roles
        MoulinRouge::Permission.all.each do |role, permission|
          if model.send(MoulinRouge.configuration.test_method, role)
            permission.collect_abilities.each { |ability| can(*ability.args, &ability.block); p ability.args }
          end
        end
      end
    end
  end
end