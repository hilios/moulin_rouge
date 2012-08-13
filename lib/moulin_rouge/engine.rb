require 'rails'
module MoulinRouge
  class Engine < ::Rails::Engine
    # isolate_namespace MoulinRouge

    initializer "moulin_rouge" do |app|
      MoulinRouge.run! # Starts the MoulinRouge magic!
    end
  end
end