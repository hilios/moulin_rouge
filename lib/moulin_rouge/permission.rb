module MoulinRouge
  class PermissionNotFound < Exception; end
  # A wrapper to catch and store the DSL methods
  class Permission
    CANCAN_METHODS = [:can, :cannot, :can?, :cannot?]
    # Returns a string with the given name
    attr_reader :singular_name
    
    # Returns a instance of the parent permission.
    # When nil this is the main permission.
    attr_reader :parent

    # Returns true if it's a group or flase otherwise
    attr_reader :is_a_group
    
    # Creates a new permission and evaluate the given block
    # with roles, groups and abilities on this scope.
    # If the parent is a group append all their abilities to self
    def initialize(name, options = {}, &block)
      @singular_name  = name
      @parent         = options.delete(:parent)
      @is_group       = options.delete(:group)
      abilities.concat(parent.abilities) if not parent.nil? and parent.group?
      instance_eval(&block) if block_given?
      # Store this permission
      self.class.add(self) unless parent.nil? or @is_group
    end

    def method_missing(name, *args, &block)
      if CANCAN_METHODS.include?(name)
        store_method(name, *args, &block) 
      else
        super(name, *args, &block)
      end
    end
    
    # Define a new role inside this scope. If exists a role with the 
    # same name evaluate the block inside them instead of create a new one
    def role(name, options = {}, &block)
      if children = find(name)
        children.instance_eval(&block)
        children
      else
        childrens << self.class.new(name, options.merge!({:parent => self}), &block)
        childrens.last
      end
    end

    # Define a group inside this scope
    def group(name, options = {}, &block)
      options.merge!({:group => true})
      role(name, options, &block)
    end

    # Returns true if is a group
    def group?
      @is_group
    end

    # Add the given parameters to the authorizations list
    def store_method(name, *args, &block)
      abilities << MoulinRouge::CanCan::Method.new(name, *args, &block)
      abilities.last
    end

    # Returns an array with all childrens
    def childrens
      @childrens ||= []
    end

    # Returns an array with all authorizations declared on this permission
    def abilities
      @abilities ||= []
    end

    # Returns all abilities for this permission.
    # If this is a group, grab the abilities from parent.
    def inherithed_abilities
      abilities.concat(childrens.map(&:inherithed_abilities).flatten).uniq
    end
    
    # Execute all files in the given path in the class scope
    def import(path)
      Dir[path].each { |file| eval(File.open(file).read) }
    end
    
    # Returns the instance of the children with the given name if exists and nil otherwise
    def find(name)
      childrens.each { |children| return children if children.name == name or children.singular_name == name }
     return nil
    end

    # Appends all childrens and abilities from one object to another,
    # raises an error if could not found a match.
    def include(name)
      unless from = self.class.all[name]
        raise PermissionNotFound
      end
      from.childrens.each { |children| childrens << children.dup }
      from.abilities.each { |ability|  abilities << ability.dup  }
    end
    
    # Returns a symbol with the name appended with the parents separeted by a underscore
    def name
      unless @name
        @name  = []
        @name << self.parent.name.to_s if not self.parent.nil? and not self.parent.parent.nil?
        @name << self.singular_name.to_s
        @name  = @name.join('_')
      end
      @name.to_sym
    end
    
    class << self
      # The instance of the main container, if don't exist create one
      def main
        @@main ||= self.new(:main)
      end
      # Returns an array with the name of all roles created
      def list
        @@list ||= []
      end

      # Returns an hash with all permissions defined
      def all
        @@all ||= {}
      end

      # Stores the instance on the all hash and add the name to the list
      def add(instance)
        name = instance.name
        self.all[name] = instance
        self.list << name unless self.list.include?(name)
      end

      # Reset all constants
      def reset! #:nodoc:
        @@main, @@list, @@all = nil
      end
    end
  end
end