require 'rbconfig'

module MoulinRouge
  class Configuration
    attr_accessor :path, :test_method
    
    def initialize
      @path = "app/permissions/**/*.rb"
      @test_method = :'is?'
    end
  end
end