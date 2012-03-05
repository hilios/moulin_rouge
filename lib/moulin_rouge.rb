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
    
    # Require the DSL and glob the path and require all permissions
    def self.run
      require 'moulin_rouge/dsl'
      Dir[MoulinRouge.configuration.path].each { |f| require f }
    end
end
