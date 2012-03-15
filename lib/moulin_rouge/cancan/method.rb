module MoulinRouge
  module CanCan
    class Method
      attr_reader :name, :args, :block
      def initialize(name, *args, &block)
        @name, @args, @block = name, args, block
      end

      # Send this method to the given object
      def send_to(object)
        # Evaluate any proc in args
        if args.last.is_a?(Hash)
          args.last.each do |key, value|
            if value.is_a?(Proc)
              args.last[key] = value.call(object)
            end
          end
        end
        # Send
        object.send(name, *args, &block)
      end
    end
  end
end