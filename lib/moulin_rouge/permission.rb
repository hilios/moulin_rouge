module MoulinRouge
  # Raised when the permission name cannot be setted
  class InvalidPermissionName < Exception; end
  
  # A wrapper to catch and store the DSL methods
  class Permission
    # Holds the name of this permission.
    attr_reader :name
    
    # Holds parent instance of this permission.
    attr_reader :parent
    
    # Store all autorizations evaluated in this scope
    attr_reader :authorizations
    
    # Creates a new permission class and evaluate the given
    # block on this class scope.
    def initialize(name, parent = nil, &block)
      @name = name
      @parent = parent
      @authorizations = []
      instance_eval(&block) if block_given?
      # Add this instance to the list inside singleton object
      Permission.list << self
    end
    
    # Returns a new Permission with the parent setted to self
    def role(name, &block)
      Permission.new(name, self, &block)
    end
    alias :group :role
    
    # Save the given parameters to the authorizations list
    def can(*args, &block)
      @authorizations << Authorization.new(args, block)
    end
    
    def ==(permission)
      @name == permission.name and @parent == permission.parent
    end
    
    class << self
      # Holds a list with every object created
      def list
        @@permissions ||= []
      end
    end
  end
end