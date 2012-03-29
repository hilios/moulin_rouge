require 'rails/generators'

module MoulinRouge
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Installs the gem folder structure"

      def generate_folder_structure
        initializer("moulin_rouge.rb", "initializer.rb")
        generate("moulin_rouge:permission", "admin")
      end
    end
  end
end