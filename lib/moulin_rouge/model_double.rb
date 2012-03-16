module MoulinRouge
  class ModelDouble
    # Return an block for later evaluation
    def method_missing(name, *args, &block)
      lambda do |scope|
        scope.send(name.to_sym, *args, &block)
      end
    end
  end
end