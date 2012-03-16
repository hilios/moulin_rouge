module MoulinRouge
  module CanCan
    # A cleaner implementation of CanCan #load_and_authorize_resource method.
    # Everytime you use the #respond_with method, send the given resources to check
    # the authorizations.
    class Responder # < ActionController::Responder
      def initialize(controller, resources, options={})
        super
        @skip_authorization = options.delete(:skip_authorization)
      end

      def to_html
        resources.each do |resource|
          action = resources.last == resource ? controller.params[:action].to_sym : :show
          controller.authorize!(action, resource_class_or_instace(resource)) unless skip?(resource)
        end
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
        if resource.is_a? Array
          if resource.empty?
            variable_name(resource).classify.constantize # raises NameError when a match is not found
          else
            resource.first.class.name
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
