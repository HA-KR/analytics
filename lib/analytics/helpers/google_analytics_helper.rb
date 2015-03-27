module Analytics
  module Helpers
    module GoogleAnalyticsHelper

      def analytics handle, *args, &block
        opts = args.extract_options!
        wrap_script = opts.delete :wrap_script
        code = ""
        args << opts
        code << handle.tracking_code(*args) if opts.delete(:init)
        content = Analytics::Models::Tokens.parse capture(&block), safe_handle(handle)
        if block_given?
          code << if wrap_script == false
                    content
                  else
                    <<-HTML
                    <script type='text/javascript'>
                    #{content}
                    </script>
                    HTML
                  end
        end
        if block_called_from_erb?(block)
          concat(code)
        else
          code
        end
      end

      #converts an Object to Safe format
      #Object             => Hash
      def safe_handle handle
        case handle
        when ActiveRecord::Base
          handle.attributes
        #when Analytics::Models::Base
          #handle.readonly
        else
          handle.instance_values
        end
      end

    end
  end
end

