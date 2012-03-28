module MoulinRouge
  # Creates a common scope to register roles and abilities
  class Authorization
    # Avoid direct initialization, just act as a singleton
    private_class_method :new

    class << self
      # Delegates the missing method for the main ability
      def method_missing(name, *args, &block)
        main.send(name, *args, &block)
      end

      # The instance of the main ability
      def main
        @main ||= MoulinRouge::Ability.new(:main)
      end

      # Returns an array with the name of all roles created
      def roles
        @roles ||= []
      end

      # Returns an hash with all permissions defined
      def abilities
        @abilities ||= {}
      end

      # Register an ability in the singleton
      def register(instance)
        name = instance.name
        self.abilities[name] = instance
        self.roles << name unless self.roles.include?(name)
      end

      # Load and initialize all authorization files in the configuration path
      def compile!
        Dir[MoulinRouge.configuration.path].each { |file| Kernel.load(file) }
      end

      # Reset all constants
      def reset! #:nodoc:
        @main, @roles, @abilities = nil
      end
    end
  end
end