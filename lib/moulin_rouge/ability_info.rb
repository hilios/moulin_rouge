module MoulinRouge
  class AbilityInfo
    attr_reader :args, :block
    def initialize(*args, &block)
      @args, @block = args, block
    end
  end
end