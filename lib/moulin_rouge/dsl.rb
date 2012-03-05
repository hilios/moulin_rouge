require 'moulin_rouge/permission'

module MoulinRouge
  module DSL
    # Return a new Permission
    def role(name, &block)
      MoulinRouge::Permission.new(name, nil, &block)
    end
    alias :group :role
  end
end

include MoulinRouge::DSL