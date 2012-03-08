module MoulinRouge
  module Role
    class Array < Array
      
      # Append the values
      def +(*args)
        self.push(*args)
      end
      
      # Removes the values
      def -(*args)
        self.reject! { |item| args.include?(item) }
      end
      
      # Do not allow to push repeted values
      def push(*args)
        super(*args) unless self.include?(*args)
      end
    end
  end
end