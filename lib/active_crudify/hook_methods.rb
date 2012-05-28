module ActiveCrudify
  module HookMethods
    private

      def before_create
        before_action
      end

      def before_update
        before_action
      end

      def before_destroy
        before_action
      end

      def before_action
        true
      end

  end
end
