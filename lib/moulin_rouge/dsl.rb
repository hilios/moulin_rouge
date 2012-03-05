module MoulinRouge
  module DSL
    # Define a role
    def role(name, &block)
    end
    alias :group :role
    # Just store the ability to apply later
    def can(*args, &block)
    end
  end
end

include MoulinRouge::DSL