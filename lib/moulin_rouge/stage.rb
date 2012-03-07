module MoulinRouge
  # A wrapper to catch and store the DSL methods
  class Stage
    # Returns a string with the given name
    attr_reader :name
    
    # Returns a instance of the parent stage.
    # When nil this is the main stage.
    attr_reader :parent
    
    # Creates a new stage and evaluate the given block
    # with roles, groups and abilities on this scope.
    def initialize(name, parent = nil, &block)
      @name = name
      @parent = parent
      @abilities = []
      instance_eval(&block) if block_given?
    end
    
    # Define a new role inside the scope of this stage
    def role(name, &block)
      if children = find(name)
        children.instance_eval(&block)
        children
      else
        childrens << self.class.new(name, self, &block)
        childrens.last
      end
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
    
    # Execute all files in the given path in the class scope
    def import(path)
      Dir[path].each { |file| eval(File.open(file).read) }
    end
    
    # Returns true if the name and parent of both object are the same and false otherwise
    def find(name)
      childrens.each { |children| return children if children.name == name }
     return nil
    end
    
    class << self
      # The instance of the main container, if don't exist create one
      def main
        @@main ||= self.new(:main)
      end
    end
  end
end