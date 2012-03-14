Dir[File.expand_path("moulin_rouge/**/*.rb", File.dirname(__FILE__))].each {|f| require f;}

module MoulinRouge
    # Returns the global Configuration object.
    def self.configuration
      @configuration ||= MoulinRouge::Configuration.new
    end

    # Yields the global configuration to a block.
    def self.configure
      yield configuration if block_given?
    end
    
    # Create the main permission, import all permission files and
    # define the Ability class require for CanCan
    def self.run!
      self.load!
      # Create the ability class
      Object.const_set 'Ability', Class.new(MoulinRouge::CanCan::Ability) unless Object.const_defined? 'Ability'
      # Change flag
      @@run = true
    end

    # Import all permission files in the configuration
    def self.load!
      MoulinRouge::Permission.main.import(MoulinRouge.configuration.path)
    end

    # Returns true if the run! method was called and false oterwise
    def self.run?
      @@run ||= false
    end

    # Reset all permission and load them again
    def self.reload!
      reset!
      load!
    end

    # Reset all constants
    def self.reset! #:nodoc:
      MoulinRouge::Permission.reset!
    end
end
