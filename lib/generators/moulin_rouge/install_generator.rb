require 'rails/generators'

module MoulinRouge
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Installs the gem folder structure"

      def generate_folder_structure
        copy_file("initializer.rb", "config/initializers/moulin_rouge.rb")
        generate("moulin_rouge:permission", "user")
      end
    end
  end
end