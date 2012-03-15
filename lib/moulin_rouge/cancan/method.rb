module MoulinRouge
  module CanCan
    class Method
      attr_reader :name, :args, :block
      def initialize(*args, &block)
        @name = :can
        @args, @block = args, block
      end

      # Send this method to the given object
      def send_to(object)
        object.send(name, *args, &block)
      end
    end
  end
end