require 'moulin_rouge/group'

module MoulinRouge
  module DSL
    # Return a new Permission
    def role(name, &block)
      MoulinRouge::Group.new(name, nil, &block)
    end
    alias :group :role
  end
end

include MoulinRouge::DSL