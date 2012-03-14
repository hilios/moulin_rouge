require 'cancan'

module MoulinRouge
  module CanCan
    class Ability
      include ::CanCan::Ability

      # Define all permissions collect by MoulinRouge
      def initialize(model)
        MoulinRouge.reset! unless MoulinRouge.configuration.cache

        MoulinRouge::Permission.all.each do |role, permission|
          if model.send(MoulinRouge.configuration.test_method, role)
            permission.collect_abilities.each { |ability| can(*ability.args, &ability.block) }
          end
        end
      end
    end
  end
end