require 'rbconfig'

module MoulinRouge
  class Configuration
    attr_accessor :path, :root
    
    def initialize
      @path = "app/permissions/**/*.rb"
    end
  end
end