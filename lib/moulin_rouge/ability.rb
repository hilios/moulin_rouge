module MoulinRouge
  class Ability
    attr_accessor :args, :block
    def initialize(args, block)
      @args, @block = args, block
    end
  end
end