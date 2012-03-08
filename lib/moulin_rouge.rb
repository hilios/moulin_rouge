Dir[File.expand_path("model_shifter/**/*.rb", File.dirname(__FILE__))].each {|f| require f;}

module MoulinRouge
    # Returns the global Configuration object.
    def self.configuration
      @configuration ||= MoulinRouge::Configuration.new
    end

    # Yields the global configuration to a block.
    def self.configure
      yield configuration if block_given?
    end
    
    # Create the main stage and execute all permission files
    def self.run!
      MoulinRouge::Stage.main.import(MoulinRouge.configuration.path)
    end
    
    # Returns an array with the name of all roles created
    def self.roles_list
      @@roles_list ||= []
    end
end
