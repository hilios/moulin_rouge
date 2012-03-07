require 'rbconfig'

module MoulinRouge
  class Configuration
    attr_accessor :path
    
    def initialize
      @path = "app/permissions/**/*.rb"
    end
  end
end