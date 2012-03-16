require 'rbconfig'

module MoulinRouge
  class Configuration
    attr_accessor :path, :test_method, :cache, :model_instance, :model
    
    def initialize
      @path           = "app/permissions/**/*.rb"
      @test_method    = :is?
      @cache          = true
      @model          = nil
      @model_instance = :current_user
    end
  end
end