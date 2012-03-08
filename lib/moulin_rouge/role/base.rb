require 'active_support/concern'

module MoulinRouge
  module Role
    module Base
      extend ActiveSupport::Concern
      
      included do
        
      end
      
      module ClassMethods
        
      end
      
      module InstanceMethods
        # Returns an array with the assigned roles
        def roles
          @roles ||= []
        end
        
        def roles_list
          
        end
      end
    end
  end
end