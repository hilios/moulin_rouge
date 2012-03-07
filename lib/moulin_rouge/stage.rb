module MoulinRouge
  # A wrapper to catch and store the DSL methods
  class Stage
    # Returns a string with the given name
    attr_reader :name
    
    # Returns a instance of the parent stage.
    # When nil this is the root stage.
    attr_reader :parent
    
    # Creates a new stage and evaluate the given block
    # with roles, groups and abilities on this scope.
    def initialize(name, parent = nil, &block)
      @name = name
      @parent = parent
      @abilities = []
      instance_eval(&block) if block_given?
      # Add this instance to the list inside singleton object
      self.class.root = self if parent.nil?
    end
    
    # Define a new role inside the scope of this stage
    def role(name, &block)
      childrens << self.class.new(name, self, &block)
      childrens.last
    end
    alias :group :role
    
    # Save the given parameters to the authorizations list
    def can(*args, &block)
      @abilities << AbilityInfo.new(args, block)
    end

    # Returns an array with all childrens
    def childrens
      @childrens ||= []
    end

    # Returns an array with all authorizations declared on this stage
    def abilities
      @abilities ||= []
    end
    
    class << self
      # Holds the root container
      def root
        @@root ||= nil
      end
      # Set the root container
      def root=(instance)
        @@root = instance
      end
    end
  end
end