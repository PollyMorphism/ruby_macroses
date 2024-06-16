module RescueFrom
  # This method is called when the module is included in another class
  def self.included(base)
    # Extend the base class with the ClassMethods module
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Class methods to be added to the base class
    def rescue_from(exception_class, with:)
      @exception_handlers ||= {}
      @exception_handlers[exception_class] = with
    end

    # This hook is called whenever a method is added to the class
    def method_added(method_name)
      # Prevent recursion
      return if @adding_method

      @adding_method = true

      # Store the original method
      original_method = instance_method(method_name)

      # Redefine the method to wrap it in a begin-rescue block
      define_method(method_name) do |*args, &block|
        begin
          #bind Unbounded method to self to make it Method
          original_method.bind(self).call(*args, &block)
        rescue => e
          handler = self.class.instance_variable_get(:@exception_handlers)[e.class]
          if handler
            send(handler, e)
          else
            raise e
          end
        end
      end

      @adding_method = false
    end
  end
end
