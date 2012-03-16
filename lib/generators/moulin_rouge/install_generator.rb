require 'rails/generators'

module MoulinRouge
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Installs the gem folder structure for the app"

      def generate_folder_structure
        directory("install")
        invoke "moulin_rouge:permission admin"
      end
    end
  end
end