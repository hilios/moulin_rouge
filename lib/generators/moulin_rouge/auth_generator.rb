require 'rails/generators'

module MoulinRouge
  module Generators
    class AuthGenerator < ::Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a new authorization file"

      argument :name

      def creates_an_authorization_file
        copy_file("authorization.rb", "app/authorizations/#{name}_authorization.rb")
      end
    end
  end
end