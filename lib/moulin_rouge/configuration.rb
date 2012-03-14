require 'rbconfig'

module MoulinRouge
  class Configuration
    attr_accessor :path, :test_method, :cache
    
    def initialize
      @path = "app/permissions/**/*.rb"
      @test_method = :is?
      @cache = true
    end
  end
end