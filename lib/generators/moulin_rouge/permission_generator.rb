require 'rails/generators'

module MoulinRouge
  module Generators
    class AuthorizationGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a new permission file inside the permission folder"

      argument :name

      def creates_a_permission_file
        copy_file("permission.rb", "app/permissions/#{name}.rb")
      end
    end
  end
end