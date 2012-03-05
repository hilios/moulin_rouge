require 'moulin_rouge/permission'

module MoulinRouge
  module DSL
    # Define a role in the system.
    # Inside
    def role(name, &block)
      MoulinRouge::Permission.new(name, nil, &block)
    end
    alias :group :role
  end
end

include MoulinRouge::DSL