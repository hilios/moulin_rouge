require 'action_controller'
module MoulinRouge
  module CanCan
    # A cleaner implementation of CanCan #load_and_authorize_resource method.
    # Everytime you use the #respond_with method, send the given resources to check
    # the authorizations.
    class Responder < ::ActionController::Responder
      def initialize(controller, resources, options={})
        super
        # Check Devise
        @is_devise = controller.respond_to(:devise_controller?) and controller.devise_controller?
        @authorize_with = options.delete(:authorize_with)
        @skip_authorization = options.delete(:skip_authorization) or @check_for_devise
      end

      def respond
        resources.each do |resource|
          unless skip?(resource)
            # If no authorization is sent execute normal proxy, otherwise send directly
            if @authorize_with.nil?
              action = resources.last == resource ? controller.params[:action].to_sym : :show
              controller.authorize!(action, resource_class_or_instace(resource))
            else
              controller.authorize!(*@authorize_with)
            end
          end
        end unless @is_devise
        super # Continue through method chain
      end

    private

      # Returns the resource class or current instance.
      #
      # Try to return a valid class for this resource.
      # It will try 3 strategies, in the following order:
      #   1. If is an array and is not empty get the class name from first item
      #   2. If is an empty array, tries to predict the class from variable name,
      #      this strategy relies on Rails naming conventions
      #   3. Just return the given resource, assuming that already is the class
      def resource_class_or_instace(resource)
        if resource.is_a? ActiveRecord::Relation or resource.is_a? Array
          if resource.empty?
            variable_name(resource).classify.constantize # raises NameError when a match is not found
          else
            resource.first.class
          end
        else
          resource
        end
      end

      # Returns the variable name that contains that resource
      def variable_name(resource)
        name = controller.instance_variables.index { |var| controller.instance_variable_get(var) === resources.first }
        name = controller.instance_variables[name].to_s.gsub(/@/, '') if name
        name.to_s
      end

      # Return true or false if resource is matched to skip
      # If skip is a symbol skip resource with same name
      # If skip is a array see if includes the resouce
      # Otherwise send the param through
      def skip?(resource)
        resource_name = variable_name(resource)

        if @skip_authorization.is_a? Symbol
          @skip_authorization == resource_name.to_sym
        elsif @skip_authorization.is_a? Array
          @skip_authorization.include?(resource_name, resource_name.to_sym)
        else
          @skip_authorization || false
        end
      end
    end
  end
end
