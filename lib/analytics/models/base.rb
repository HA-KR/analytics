module Analytics
  module Models
    class Base
      include ContextAware

      def initialize opts={}
        opts.symbolize_keys!
        position = opts[:position]
      end

      def tracking_code
        raise "sub class should implement this method"
      end

    end
  end
end
